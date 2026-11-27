// Dorfverwaltung
// Zentrale Supabase-Verbindung

const db = window.supabase.createClient(
    SUPABASE_URL,
    SUPABASE_PUBLISHABLE_KEY
);

// Verbindungstest und Abruf der Stammdaten

async function testConnection() {

    const { data: locations, error: locationError } =
        await db
            .from("locations")
            .select("id, name")
            .order("id");

    if (locationError) {
        throw locationError;
    }

    const { data: categories, error: categoryError } =
        await db
            .from("categories")
            .select("id, name, color")
            .order("id");

    if (categoryError) {
        throw categoryError;
    }

    return {
        locations,
        categories
    };
}
