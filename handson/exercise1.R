
# Arbeitsverzeichnis definieren
setwd("C:/Users/yvessche/OneDrive - University of Helsinki/teaching/18-geoling-lmu/handson")

##########################################################################

### 1 - Hintergrundkarten von Google oder Stamen (Package ggmap)

library(ggmap)

# Karte von Google Maps herunterladen
map1 = get_googlemap("Spitzingsee", maptype = "terrain", zoom = 9)
ggmap(map1)

# Hilfe f�r die Funktion get_googlemap:
??get_googlemap
# Welche anderen Kartentypen sind verf�gbar? Wie unterscheiden sie sich visuell?
# Testen Sie andere Werte des Zoom-Niveaus!
# Google Maps erkennt die Ortschaft "Spitzingsee" automatisch. Testen Sie andere Ortsbezeichnungen!

# Hinweis: Die Nutzung des Google Maps API ist beschr�nkt (beschr�nkte Anzahl Anfragen pro Tag).
# Ab 16. Juli 2018 soll die Nutzung des Google Maps API nur noch mit Anmeldung m�glich sein.
# Dokumentation von ggmap beachten!

# Mit der Funktion geocode() kann man die Koordinaten eines Ortes mit Hilfe von Google Maps errechnen,
# ohne gleich eine Karte zeichnen zu m�ssen:
coords = geocode("Spitzingsee")
coords$lon
coords$lat

# L�ngen- und Breitengrade von Bayern (Wie findet man die am besten heraus?)
bayern = c(left = 8.7, bottom = 47, right = 14, top = 51)
# Karte von Stamen herunterladen (http://maps.stamen.com, Kartenquelle ist OpenStreetMaps)
map2 = get_stamenmap(bayern, maptype="toner-lite", zoom = 7)
ggmap(map2)

# Betrachten Sie die Hilfe-Seite von get_stamenmap und versuchen Sie, andere Kartentypen darzustellen!
# get_stamenmap braucht je zwei L�ngen- und Breitengrade, um den Kartenausschnitt zu definieren

# Karten aus dem Speicher entfernen
rm(map1, map2)


##########################################################################

### 2 - Polygondaten von GADM (Package raster)

library(raster)

# https://gadm.org/ stellt Karten mit Gebietsgrenzen aller L�nder zur Verf�gung
map1 = getData("GADM", country="Italy", level=1)
# Karte ins Lat/Long-Koordinatensystem konvertieren
# Diese Konversion hat keinen Einfluss auf die Darstellung, ist aber wichtig,
# wenn mehrere Datens�tze kombiniert werden sollen.
map1 = spTransform(map1, CRS("+proj=longlat +datum=WGS84"))
plot(map1)
# Es gibt Levels 0, 1, 2 und 3. Wof�r stehen diese Zahlen?

# Mit jedem Polygon des Datensatzes sind Informationen assoziiert.
# Hier sind die Informationen zu den 6 ersten Polygonen im Datensatz:
head(map1@data)

# Karten aus dem Speicher entfernen
rm(map1)


##########################################################################

### 3 - Polygondaten aus Shapefiles einlesen (Package rgdal)

library(rgdal)

# Der Datensatz ist im Unterverzeichnis data und heisst G3S08
# Dieser Datensatz ist im Shapefile-Format, d.h. er besteht aus mehreren Dateien,
# die alle mit G3S08 anfangen. Alle diese Dateien m�ssen sich im gleichen Verzeichnis befinden.
map1 = readOGR(dsn="data", layer="G3S08")
map1 = spTransform(map1, CRS("+proj=longlat +datum=WGS84"))
plot(map1)
# Was enth�lt dieser Datensatz? Was enthalten die Datens�tze G3L08 und G3B08?

# Diese Datens�tze entstammen einer �lteren Version von swissBOUNDARIES3D, frei verf�gbar unter:
# https://shop.swisstopo.admin.ch/en/products/landscape/boundaries3D
# �hnliche Datens�tze werden auch von anderen L�ndern herausgegeben, z.B. IGN Frankreich:
# http://professionnels.ign.fr/adminexpress

# Alle italienischsprachigen Bezirke der Schweiz darstellen
map2 = readOGR(dsn="data", layer="G3B08", encoding="iso-8859-1")
head(map2@data)
# Mittels trial and error herausfinden, dass die Kantonsnummer 21 f�r Tessin steht...
mapTI = map2[which(map2@data$KT == 21), ]
head(mapTI@data)
plot(mapTI)

mapGR = map2[which(map2@data$NAME == "Bernina" | map2@data$NAME == "Moesa"), ]
tail(mapGR@data)
plot(mapGR)

mapItal = rbind(mapTI, mapGR)
plot(mapItal)

rm(map1, map2, mapTI, mapGR, mapItal)


##########################################################################

### 4 - Punktdaten aus Textdatei einlesen (ggplot2)

library(ggplot2)

df = read.table("data/sds-ortsnetz.txt", header=T, sep="\t", quote="", dec=".", fileEncoding="utf-8")
head(df)

# ggplot() stellt eine leere Zeichenoberfl�che dar
# geom_point() f�gt Punktdaten hinzu
# coord_map() skaliert die Karte automatisch gem�ss einer Projektion
# Wie ver�ndert sich die Karte, wenn sie coord_map() weglassen?
ggplot() + geom_point(data=df, aes(x=LONG, y=LAT), shape=19, size=3) + coord_map()

# Was bedeutet "shape=19"?
# Die von R unterst�tzten Symbolarten sind hier aufgelistet:
# http://www.cookbook-r.com/Graphs/Shapes_and_line_types/

# Anstatt LONG und LAT k�nnen Sie auch die Felder POINT_X und POINT_Y benutzen
# (schweizerisches Koordinatensystem CH1903)
# Diese Projektion ist aber nicht in coord_map() definiert

rm(df)


##########################################################################

# 5 - Attribute aus Textdatei einlesen

df = read.table("data/4168_nicht_mehr_categ.txt", header=T, sep="\t", quote="", dec=".", fileEncoding="utf-8")
head(df)
