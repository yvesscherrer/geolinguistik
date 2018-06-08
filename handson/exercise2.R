
# Arbeitsverzeichnis definieren
setwd("C:/Users/yvessche/OneDrive - University of Helsinki/teaching/18-geoling-lmu/handson")

##########################################################################

### 1 - Einfache Punktkarte

library(ggplot2)

# Geodaten laden
sds_punkte = read.table("data/sds-ortsnetz.txt", header=T, sep="\t", quote="", dec=".", fileEncoding="utf-8")

# Attribute laden
sds_attr = read.table("data/4168_nicht_mehr_categ.txt", header=T, sep="\t", quote="", dec=".", fileEncoding="utf-8")

# Wie heissen die verschiedenen Felder der beiden Tabellen?
# Welches Feld ist der Schlüssel, der die beiden Tabellen verbindet?

# Geodaten mit Attributen verbinden ("inner join" in Datenbank-Terminologie)
sds_joined = merge(x=sds_punkte, y=sds_attr, by="SDS_CODE")
head(sds_joined)

# Darstellung, je eine andere Farbe pro Variante
ggplot() +
  geom_point(data=sds_joined, aes(x=LONG, y=LAT, color=VARIANT), shape=19, size=3) +
  coord_map()


### 2 - Kartenhintergrund mit ggmap hinzufügen

library(ggmap)

ch = c(left=5.5, right=11, top=48, bottom=45.5)
backgr = get_stamenmap(ch, maptype="terrain-background", color="bw", zoom = 7)

# anstatt ggplot() nehmen wir nun ggmap() mit dem Hintergrundbild
ggmap(backgr) +
    geom_point(data=sds_joined, aes(x=LONG, y=LAT, color=VARIANT), shape=19, size=3) +
    coord_map()


### 3 - Landesgrenze und Sprachgrenze hinzufügen

library(rgdal)

land = readOGR(dsn="data", layer="G3L08")
land = spTransform(land, CRS("+proj=longlat +datum=WGS84"))

sprgr = readOGR(dsn="data", layer="chde")
sprgr = spTransform(sprgr, CRS("+proj=longlat +datum=WGS84"))

ggmap(backgr) +
  geom_polygon(data=land, aes(x=long, y=lat), fill="transparent", color="black", size=1) +
  geom_polygon(data=sprgr, aes(x=long, y=lat), fill="transparent", color="black", size=1) +
  geom_point(data=sds_joined, aes(x=LONG, y=LAT, color=VARIANT), shape=19, size=2) +
  coord_map()


### 4 - Farben manuell wählen

# Die von R unterstützten Farbnamen sind hier aufgelistet:
# http://sape.inf.usi.ch/quick-reference/ggplot2/colour
farben = c("nüme"="tomato", "nimme"="red3", "nümm"="tan1", "nimmi"="darkorange1",
           "nümee"="slateblue1", "nimee"="slateblue4", "nütmee"="palegreen1", "nitmee"="palegreen4",
           "nomme"="violetred1", "numme"="darkorchid")

ggmap(backgr) +
  geom_polygon(data=land, aes(x=long, y=lat), fill="transparent", color="black", size=1) +
  geom_polygon(data=sprgr, aes(x=long, y=lat), fill="transparent", color="black", size=1) +
  geom_point(data=sds_joined, aes(x=LONG, y=LAT, color=VARIANT), shape=19, size=2) +
  coord_map() +
  scale_color_manual(values=farben)


### 5 - Achsenbeschriftungen entfernen und Karte speichern

# Grafik in einer Variablen speichern anstatt direkt auszuführen (d.h. darzustellen)
g = ggmap(backgr) +
  geom_polygon(data=land, aes(x=long, y=lat), fill="transparent", color="black", size=1) +
  geom_polygon(data=sprgr, aes(x=long, y=lat), fill="transparent", color="black", size=1) +
  geom_point(data=sds_joined, aes(x=LONG, y=LAT, color=VARIANT), shape=19, size=2) +
  coord_map() +
  scale_color_manual(values=farben) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())

# Ausführung von g = Darstellung
g

# Speicherung
# Achtung: Legenden werden u.U. anders dargestellt als in der Vorschau!
ggsave(g, filename="nichtmehr.png", scale=1, width=39.78, height=26.59, units="cm")
