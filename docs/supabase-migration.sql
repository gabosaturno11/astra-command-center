-- ASTRA Command Center — Supabase Migration
-- Run this in Supabase SQL Editor (same project as Client OS)
-- Table prefix: astra_ (shares project with cos_, bonus_, beast_)

-- ===== PROJECTS =====
CREATE TABLE IF NOT EXISTS astra_projects (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL DEFAULT '',
    description TEXT DEFAULT '',
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'paused', 'complete', 'archived')),
    color TEXT DEFAULT '#06b6d4',
    icon TEXT DEFAULT 'folder',
    instructions TEXT DEFAULT '',
    links JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===== CONTENT (vault items) =====
CREATE TABLE IF NOT EXISTS astra_content (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL DEFAULT '',
    body TEXT DEFAULT '',
    type TEXT DEFAULT 'note',
    theme TEXT DEFAULT '',
    tags TEXT[] DEFAULT '{}',
    project_id TEXT,
    pinned BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===== TASKS =====
CREATE TABLE IF NOT EXISTS astra_tasks (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL DEFAULT '',
    description TEXT DEFAULT '',
    status TEXT DEFAULT 'todo' CHECK (status IN ('todo', 'progress', 'done', 'blocked')),
    priority TEXT DEFAULT 'p2' CHECK (priority IN ('p0', 'p1', 'p2', 'p3')),
    project TEXT DEFAULT '',
    project_id TEXT,
    due DATE,
    tags TEXT[] DEFAULT '{}',
    subtasks JSONB DEFAULT '[]'::jsonb,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===== LINKS =====
CREATE TABLE IF NOT EXISTS astra_links (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL DEFAULT '',
    url TEXT NOT NULL DEFAULT '',
    description TEXT DEFAULT '',
    category TEXT DEFAULT 'general',
    project_id TEXT,
    tags TEXT[] DEFAULT '{}',
    pinned BOOLEAN DEFAULT false,
    read_later BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===== DOCS (Writer) =====
CREATE TABLE IF NOT EXISTS astra_docs (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL DEFAULT '',
    body TEXT DEFAULT '',
    project_id TEXT,
    versions JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===== SPECS (Living Docs) =====
CREATE TABLE IF NOT EXISTS astra_specs (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL DEFAULT '',
    sections JSONB DEFAULT '[]'::jsonb,
    project_id TEXT,
    icon TEXT DEFAULT 'file',
    color TEXT DEFAULT '#06b6d4',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===== KNOWLEDGE BASE =====
CREATE TABLE IF NOT EXISTS astra_knowledge_base (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL DEFAULT '',
    type TEXT DEFAULT 'md',
    storage TEXT DEFAULT 'inline',
    content TEXT DEFAULT '',
    description TEXT DEFAULT '',
    tags TEXT[] DEFAULT '{}',
    project_id TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===== CALENDAR EVENTS =====
CREATE TABLE IF NOT EXISTS astra_calendar (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL DEFAULT '',
    date DATE NOT NULL,
    time TEXT DEFAULT '',
    duration INTEGER DEFAULT 60,
    project_id TEXT,
    type TEXT DEFAULT 'event',
    notes TEXT DEFAULT '',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===== WHITEBOARD =====
CREATE TABLE IF NOT EXISTS astra_whiteboard (
    id TEXT PRIMARY KEY DEFAULT 'main',
    nodes JSONB DEFAULT '[]'::jsonb,
    connections JSONB DEFAULT '[]'::jsonb,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===== GABO RANTS (personal brain dump) =====
CREATE TABLE IF NOT EXISTS astra_rants (
    id TEXT PRIMARY KEY,
    text TEXT NOT NULL DEFAULT '',
    context TEXT DEFAULT '',
    project TEXT DEFAULT '',
    tags TEXT[] DEFAULT '{}',
    sentiment TEXT DEFAULT '',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===== PIPELINE RESULTS =====
CREATE TABLE IF NOT EXISTS astra_pipeline_results (
    id TEXT PRIMARY KEY,
    input_type TEXT DEFAULT 'text',
    transcript TEXT DEFAULT '',
    prompt TEXT DEFAULT '',
    synthesis TEXT DEFAULT '',
    engine TEXT DEFAULT 'auto',
    source TEXT DEFAULT '',
    duration REAL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===== SETTINGS =====
CREATE TABLE IF NOT EXISTS astra_settings (
    key TEXT PRIMARY KEY,
    value JSONB NOT NULL DEFAULT '{}'::jsonb,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===== INDEXES =====
CREATE INDEX IF NOT EXISTS idx_astra_content_project ON astra_content(project_id);
CREATE INDEX IF NOT EXISTS idx_astra_content_type ON astra_content(type);
CREATE INDEX IF NOT EXISTS idx_astra_tasks_status ON astra_tasks(status);
CREATE INDEX IF NOT EXISTS idx_astra_tasks_project ON astra_tasks(project_id);
CREATE INDEX IF NOT EXISTS idx_astra_tasks_due ON astra_tasks(due);
CREATE INDEX IF NOT EXISTS idx_astra_tasks_priority ON astra_tasks(priority);
CREATE INDEX IF NOT EXISTS idx_astra_links_project ON astra_links(project_id);
CREATE INDEX IF NOT EXISTS idx_astra_docs_project ON astra_docs(project_id);
CREATE INDEX IF NOT EXISTS idx_astra_specs_project ON astra_specs(project_id);
CREATE INDEX IF NOT EXISTS idx_astra_kb_project ON astra_knowledge_base(project_id);
CREATE INDEX IF NOT EXISTS idx_astra_calendar_date ON astra_calendar(date);
CREATE INDEX IF NOT EXISTS idx_astra_rants_created ON astra_rants(created_at);
CREATE INDEX IF NOT EXISTS idx_astra_pipeline_created ON astra_pipeline_results(created_at);
CREATE INDEX IF NOT EXISTS idx_astra_pipeline_source ON astra_pipeline_results(source);

-- ===== RLS POLICIES =====
ALTER TABLE astra_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE astra_content ENABLE ROW LEVEL SECURITY;
ALTER TABLE astra_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE astra_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE astra_docs ENABLE ROW LEVEL SECURITY;
ALTER TABLE astra_specs ENABLE ROW LEVEL SECURITY;
ALTER TABLE astra_knowledge_base ENABLE ROW LEVEL SECURITY;
ALTER TABLE astra_calendar ENABLE ROW LEVEL SECURITY;
ALTER TABLE astra_whiteboard ENABLE ROW LEVEL SECURITY;
ALTER TABLE astra_rants ENABLE ROW LEVEL SECURITY;
ALTER TABLE astra_pipeline_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE astra_settings ENABLE ROW LEVEL SECURITY;

-- Permissive policies (single-user mode — Gabo only)
CREATE POLICY "allow_all_astra_projects" ON astra_projects FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_astra_content" ON astra_content FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_astra_tasks" ON astra_tasks FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_astra_links" ON astra_links FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_astra_docs" ON astra_docs FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_astra_specs" ON astra_specs FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_astra_kb" ON astra_knowledge_base FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_astra_calendar" ON astra_calendar FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_astra_whiteboard" ON astra_whiteboard FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_astra_rants" ON astra_rants FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_astra_pipeline" ON astra_pipeline_results FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_astra_settings" ON astra_settings FOR ALL USING (true) WITH CHECK (true);

-- ===== REALTIME =====
ALTER PUBLICATION supabase_realtime ADD TABLE astra_projects;
ALTER PUBLICATION supabase_realtime ADD TABLE astra_content;
ALTER PUBLICATION supabase_realtime ADD TABLE astra_tasks;
ALTER PUBLICATION supabase_realtime ADD TABLE astra_links;
ALTER PUBLICATION supabase_realtime ADD TABLE astra_docs;
ALTER PUBLICATION supabase_realtime ADD TABLE astra_specs;
ALTER PUBLICATION supabase_realtime ADD TABLE astra_knowledge_base;
ALTER PUBLICATION supabase_realtime ADD TABLE astra_calendar;
ALTER PUBLICATION supabase_realtime ADD TABLE astra_whiteboard;
ALTER PUBLICATION supabase_realtime ADD TABLE astra_rants;
ALTER PUBLICATION supabase_realtime ADD TABLE astra_pipeline_results;
