# Projektplan

## 1. Projektbeskrivning (Beskriv vad sidan ska kunna göra)
    Jag ska göra ett sorts träningsforum där man kan skapa/planera en workout i lite mer detalj. Det ska finnas olika kategorier av workouts som t.ex styrka, kondition, någon sport etc. Varje workouts ska såklart också bestå av flera olika moves eller aktiviteter som ska utföras. Man ska även kunna ladda upp sin workout så andra kan se (om man vill), då hamnar den på en sorts global sida där alla med konton kan se (och kanske kan kommentera eller like). Det ska även finnas en sorts admin roll som kan se allas workouts (och redigera de på något sätt). Om jag hinner ska jag även lägga till en info sida som förklara basic moves och kanske ar exempel workouts som stöd.

## 2. Vyer (visa bildskisser på dina sidor)
    skickar mail
## 3. Databas med ER-diagram (Bild)
    er-diagram.JPG
## 4. Arkitektur (Beskriv filer och mappar - vad gör/inehåller de?)
    I min users map så har jag allt så har jag alla slim_filer som rör mina users. error rör när man loggar in och får ett felmeddelande. Login är slimfilen är för inloggningen/registreringen och sköter om alla placeholders och hur den menyn ser ut. I workoutsmappen har jag alla filer som rör ändringar eller visning av workoutdelar. I create_w är slimfilen för menyn där du ändrar din workout. home är dit du kommer då du loggat in och där visas alla workouts och därfirån navigerar du till alla workout funktioner. Show är den filen som visar varje workout för sig när du trycker på den. app är såklart där jag gör alla mina ändringar i min kod.
