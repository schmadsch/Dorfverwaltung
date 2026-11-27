BEGIN;
INSERT INTO public.locations (name)
VALUES ('Kleinopitz'), ('Braunsdorf'), ('Oberhermsdorf'), ('Ortsübergreifend')
ON CONFLICT (name) DO NOTHING;
INSERT INTO public.categories (name, color)
VALUES
    ('Dorffest / Feier', '#DC2626'),
    ('Vereinsveranstaltung', '#2563EB'),
    ('Feuerwehr', '#EA580C'),
    ('Kultur / Musik', '#9333EA'),
    ('Sport / Freizeit', '#16A34A'),
    ('Kinder / Familie', '#DB2777'),
    ('Arbeitseinsatz', '#92400E'),
    ('Versammlung / Sitzung', '#0891B2'),
    ('Tradition / Brauchtum', '#CA8A04'),
    ('Sonstiges', '#64748B')
ON CONFLICT (name) DO NOTHING;
COMMIT;
