# WhatsApp Business API Setup Guide for Client OS
## Webhook: https://client-os-omega.vercel.app/api/whatsapp

---

## ENVIRONMENT VARIABLES NEEDED

Set ALL of these in Vercel before testing:

| Variable | Where You Get It | What It Does |
|----------|-----------------|--------------|
| `WHATSAPP_VERIFY_TOKEN` | You create it (any string) | Shared secret between Meta and your webhook |
| `WHATSAPP_ACCESS_TOKEN` | Meta Developer Dashboard | API token to download media + send replies |
| `WHATSAPP_PHONE_NUMBER_ID` | Meta Developer Dashboard | Your WhatsApp Business phone number ID |
| `OPENAI_API_KEY` | platform.openai.com | Used for voice memo transcription (gpt-4o-mini-transcribe) |
| `SUPABASE_URL` | Supabase Dashboard | Already needed for Client OS |
| `SUPABASE_SERVICE_KEY` | Supabase Dashboard | Already needed for Client OS |

---

## STEP 1: Create a Meta Business App

1. Go to **https://developers.facebook.com/**
2. Log in with the Facebook account linked to your business
3. Click **"My Apps"** (top right)
4. Click **"Create App"**
5. Select **"Other"** as the use case, click Next
6. Select **"Business"** as the app type, click Next
7. Fill in:
   - **App name:** `Client OS WhatsApp` (or whatever you want)
   - **App contact email:** gabo@saturnomovement.com
   - **Business portfolio:** Select your existing Meta Business portfolio, or create one
8. Click **"Create App"**

---

## STEP 2: Add WhatsApp Product to Your App

1. After creating the app, you land on the **"Add products to your app"** page
2. Find **"WhatsApp"** in the product list
3. Click **"Set up"** next to WhatsApp
4. If prompted to select a Meta Business Account, select yours or create one
5. You should now see **"WhatsApp > Getting Started"** in the left sidebar

---

## STEP 3: Get Your Test Phone Number and Access Token

1. In the left sidebar, click **WhatsApp > API Setup** (or "Getting Started")
2. You will see a section called **"Temporary access token"**
   - Copy this token -- this is your `WHATSAPP_ACCESS_TOKEN`
   - NOTE: This temporary token expires in 24 hours. For production, you will generate a permanent one (Step 7)
3. Below that, you will see **"Phone number ID"** under the "From" phone number dropdown
   - Copy the **Phone number ID** (a numeric string like `123456789012345`) -- this is your `WHATSAPP_PHONE_NUMBER_ID`
4. You will also see a **test phone number** assigned to your app (something like +1 555 XXX XXXX)
   - This is the number that will send/receive messages during testing

---

## STEP 4: Add Your Personal Number as a Test Recipient

1. Still on the **API Setup** page, scroll to **"To"** section
2. Click **"Manage phone number list"** (or "Add phone number")
3. Enter your personal WhatsApp phone number (the one you will send test messages FROM)
4. You will receive a verification code via WhatsApp -- enter it
5. Your number is now approved to send/receive test messages

---

## STEP 5: Set Up the Webhook

1. In the left sidebar, click **WhatsApp > Configuration**
2. Under **"Webhook"**, click **"Edit"**
3. Fill in:
   - **Callback URL:** `https://client-os-omega.vercel.app/api/whatsapp`
   - **Verify token:** Choose any string you want (e.g., `saturno_whatsapp_2026`). You MUST use this exact same string as your `WHATSAPP_VERIFY_TOKEN` env var in Vercel
4. **BEFORE clicking "Verify and save"** -- you need to set the env var in Vercel first (Step 6). Meta will immediately send a GET request to verify the webhook, and it will fail if the env var is not set yet.

---

## STEP 6: Set Environment Variables in Vercel

1. Go to **https://vercel.com/dashboard**
2. Click on your **client-os** project
3. Go to **Settings** > **Environment Variables**
4. Add these variables (set for Production, Preview, and Development):

| Key | Value |
|-----|-------|
| `WHATSAPP_VERIFY_TOKEN` | The exact string you chose in Step 5 (e.g., `saturno_whatsapp_2026`) |
| `WHATSAPP_ACCESS_TOKEN` | The temporary token from Step 3 |
| `WHATSAPP_PHONE_NUMBER_ID` | The phone number ID from Step 3 |

5. Click **Save** for each one
6. **Redeploy the project** so the new env vars take effect:
   - Go to **Deployments** tab
   - Click the three-dot menu on the latest deployment
   - Click **"Redeploy"**
   - Wait for it to finish (should take 30-60 seconds)

---

## STEP 7 (Back to Meta): Verify the Webhook and Subscribe

1. Now go back to **https://developers.facebook.com/** > Your App > WhatsApp > Configuration
2. Click **"Edit"** under Webhook again (or if you left it open from Step 5)
3. Enter the same values:
   - **Callback URL:** `https://client-os-omega.vercel.app/api/whatsapp`
   - **Verify token:** The same string you set as `WHATSAPP_VERIFY_TOKEN`
4. Click **"Verify and save"**
   - Meta sends a GET request with `hub.mode=subscribe`, `hub.verify_token=<your token>`, `hub.challenge=<random string>`
   - Your webhook checks the token matches, returns the challenge
   - If it says "Verified" -- you are connected
5. **Subscribe to webhook fields:** After verification, you will see a list of webhook fields. Click **"Subscribe"** next to **`messages`**
   - This is the field that triggers when someone sends you a WhatsApp message (text, audio, image, video)
   - You do NOT need to subscribe to other fields unless you want delivery receipts etc.

---

## STEP 8: Test the Webhook

### Test 1: Send a text message
1. Open WhatsApp on your phone
2. Send a text message to the test phone number from Step 3
3. Check Vercel logs: Go to your Vercel project > **Deployments** > latest > **Functions** tab > click on `api/whatsapp` > view logs
4. You should see `[WhatsApp] text from <your name>: processed`

### Test 2: Send a voice memo
1. Send a voice memo to the same test number
2. The webhook will:
   - Download the audio from Meta's servers
   - Transcribe it using OpenAI (gpt-4o-mini-transcribe)
   - Create a client in Supabase (if phone number is new)
   - Create a session with the transcript
   - Upload the audio to Supabase Storage (cos-media bucket)
   - Reply on WhatsApp: "Received your voice memo (X chars transcribed). Session logged in Client OS."
3. Check the Vercel function logs for `[WhatsApp] audio from <your name>: session_created`

### Test 3: Verify in Client OS
1. Open https://client-os-omega.vercel.app
2. Check the Clients tab -- your phone number should appear as a new client
3. Check the Sessions tab -- you should see "WhatsApp Voice -- <your name>" with the transcript

---

## STEP 9: Generate a Permanent Access Token (When Ready for Production)

The temporary token from Step 3 expires in 24 hours. For production:

1. Go to **https://developers.facebook.com/** > Your App
2. In the left sidebar, click **WhatsApp > API Setup**
3. Scroll to the **"Access Tokens"** section
4. You need a **System User Token** with `whatsapp_business_messaging` permission:
   a. Go to **https://business.facebook.com/settings/system-users** (Meta Business Suite > Settings > System Users)
   b. Click **"Add"** to create a System User
   c. Give it a name like `Client OS Bot`
   d. Set role to **Admin**
   e. Click **"Generate New Token"**
   f. Select your app (`Client OS WhatsApp`)
   g. Check the permission: **`whatsapp_business_messaging`**
   h. Click **"Generate Token"**
   i. Copy the token -- this is your permanent `WHATSAPP_ACCESS_TOKEN`
5. Go back to Vercel and update the `WHATSAPP_ACCESS_TOKEN` env var with this permanent token
6. Redeploy

---

## STEP 10: Use a Real Business Phone Number (Optional, Later)

The test number can only message pre-approved recipients. To use a real business number:

1. Go to **https://developers.facebook.com/** > Your App > WhatsApp > API Setup
2. Click **"Add phone number"**
3. Enter a real phone number (must not already be registered on WhatsApp)
4. Verify via SMS or voice call
5. Update `WHATSAPP_PHONE_NUMBER_ID` in Vercel with the new phone number ID
6. Redeploy
7. Now anyone can message this number and it will flow into Client OS

---

## WHAT THE WEBHOOK HANDLES

| Message Type | What Happens |
|-------------|--------------|
| **Audio (voice memo)** | Downloads audio -> Transcribes via OpenAI -> Creates/finds client by phone -> Creates session + audio entry in Supabase -> Uploads audio to cos-media storage -> Replies on WhatsApp with confirmation |
| **Text** | If 20+ characters: saves as session note (classification: FEEDBACK) for existing client |
| **Image** | Downloads and uploads to Supabase Storage (cos-media bucket) |
| **Video** | Downloads and uploads to Supabase Storage (cos-media bucket) |

---

## SUPABASE STORAGE REQUIREMENT

The webhook uploads audio/images/videos to a Supabase Storage bucket called `cos-media`. Make sure this bucket exists:

1. Go to your Supabase project dashboard
2. Click **Storage** in the left sidebar
3. If `cos-media` bucket does not exist, click **"New bucket"**
4. Name: `cos-media`
5. Set to **Public** (so audio URLs are accessible)
6. Save

---

## TROUBLESHOOTING

| Problem | Fix |
|---------|-----|
| Webhook verification fails | Check that `WHATSAPP_VERIFY_TOKEN` in Vercel matches exactly what you entered in Meta. Redeploy after setting env vars. |
| Messages not arriving | Make sure you subscribed to the `messages` webhook field in Step 7. Check Vercel function logs. |
| Audio transcription fails | Check that `OPENAI_API_KEY` is set in Vercel. Check Vercel logs for `[WhatsApp] Transcription failed`. |
| "no_supabase" status | `SUPABASE_URL` and `SUPABASE_SERVICE_KEY` not set or wrong. |
| Media download fails | Access token expired. Generate a permanent one (Step 9). |
| 403 on webhook verify | Token mismatch or `WHATSAPP_VERIFY_TOKEN` not set. |

---

## QUICK REFERENCE

- **Meta Developer Dashboard:** https://developers.facebook.com/
- **Meta Business Settings:** https://business.facebook.com/settings/
- **Vercel Dashboard:** https://vercel.com/dashboard
- **Webhook URL:** https://client-os-omega.vercel.app/api/whatsapp
- **Supabase Dashboard:** https://supabase.com/dashboard
- **OpenAI API Keys:** https://platform.openai.com/api-keys

---

## TOTAL TIME: ~10 minutes if you have a Meta Business account already
