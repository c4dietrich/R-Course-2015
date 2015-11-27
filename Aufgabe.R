library(XML)

tokens <- vector('character')
types <- vector('character')
wortarten <- vector("character")
genus <- vector('character')


xmlEventParse(
  "R-Course-2015/data/t_990505_47.xml",
  handlers = list(
    't' = function(name, attr) {
      tokens <<- c(tokens, attr['word'])
      types <<- c(types, attr['lemma'])
      wortarten <<- c(wortarten, attr['pos'])
      genus <<- c(genus, attr['morph'])
    
    }
  ),
  addContext = FALSE
)




df <- data.frame(tokens, types, wortarten, genus) #Datenframe erstellen

geordneteTokens <- order(df$tokens)  #Tokens ordnen
df_geordnet <- df[geordneteTokens,]   

write.table(df_geordnet, file = 'sortierterDataframe.csv', sep= '\t')
# Substantive auslesen
substantive <- subset(df_geordnet, df_geordnet$wortarten == 'NN' | df_geordnet$wortarten == 'NE')
durchschnitt <- nchar(substantive) / nrow(substantive)

char_genus <- substr(substantive$genus, 3, 3) # Spalte Genus, letzten(3.) Buchstaben auslesen

substantive$m_w_n <- char_genus   #Spalte hinzufügen
anzahlGenus <- table(substantive$m_w_n) #Verteilung des Genus der Substantive zählen
anzahlGenus
# hist(anzahlGenus)
autosemantisch <- c("ADJA","ADJD", "ADV","ITJ", "NE", "NN", "VAFIN", "VAPP", "VMINF", "VMPP", "VVINF", "VVIZU", "VVPP")
autosem <- df_geordnet$wortarten %in% autosemantisch # sind Wörter autosemantisch?
df_geordnet$autosemantisch <- autosem
table(df_geordnet$autosemantisch) # Anzahl autosemantischer Woerter

