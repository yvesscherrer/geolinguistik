
# Arbeitsverzeichnis definieren
setwd("C:/Users/yvessche/OneDrive - University of Helsinki/teaching/18-geoling-lmu/handson")

##########################################################################

### 1 - Punktkarten für Frequenzverteilungen

library(ggplot2)

library(rgdal)

land = readOGR(dsn="data", layer="G3L08")
land = spTransform(land, CRS("+proj=longlat +datum=WGS84"))

sprgr = readOGR(dsn="data", layer="chde")
sprgr = spTransform(sprgr, CRS("+proj=longlat +datum=WGS84"))

punkte = read.table("data/sds-ortsnetz.txt", header=T, sep="\t", quote="", dec=".", fileEncoding="utf-8")

attr = read.table("data/sads-1-12.txt", header=T, sep="\t", quote="", dec=".")

attr_merged = merge(x=punkte, y=attr, by="SDS_CODE")

# weisser Hintergrund
# wie sieht die Grafik für die anderen Attribute aus?
ggplot() +
  geom_polygon(data=land, aes(x=long, y=lat, group=group), fill="transparent", color="black", size=1) +
  geom_polygon(data=sprgr, aes(x=long, y=lat, group=group), fill="gray80", color="transparent") +
  geom_point(data=attr_merged, aes(x=LONG, y=LAT, color=ENER), shape=19, size=3) +
  coord_map()


### 2 - Tortendiagramme

library(scatterpie)

# r: Radius (kann konstant sein oder eine Funktion einer Spalte)
# cols: relevante Spalten der Datenmatrix
ggplot() +
  geom_polygon(data=land, aes(x=long, y=lat, group=group), fill="transparent", color="black", size=1) +
  geom_polygon(data=sprgr, aes(x=long, y=lat, group=group), fill="gray80", color="transparent") +
  geom_scatterpie(aes(x=LONG, y=LAT, r=0.03), data=attr_merged, cols=c("ENER", "ENE", "EN")) +
  coord_map()

# Die Dokumentation von "scatterpie" ist ein bisschen dürftig...
# Warum sind die Diagramme verzogen? Wie kann man die Farben ändern?


### 3 - Kosmetische Verbesserungen

g = ggplot() +
  geom_polygon(data=land, aes(x=long, y=lat, group=group), fill="transparent", color="black", size=1) +
  geom_polygon(data=sprgr, aes(x=long, y=lat, group=group), fill="gray80", color="transparent") +
  geom_scatterpie(aes(x=LONG, y=LAT), data=attr_merged, cols=c("ENER", "ENE", "EN"), size=0.5, color="gray30") +
  coord_map() +
  theme(panel.background=element_rect(fill = "white", colour = "white"),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      legend.justification=c(0,0),
      axis.title.x=element_blank(),
      axis.text.x=element_blank(),
      axis.ticks.x=element_blank(),
      axis.title.y=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks.y=element_blank(),
      legend.position=c(0.01,0.05),
      legend.spacing=unit(1,"lines"),
      legend.box="vertical",
      legend.key.size=unit(1.2,"lines"),
      legend.key.height=unit(2,"line"),
      legend.text.align=0,
      legend.title.align=0,
      legend.text=element_text(size=12, color="black"),
      legend.key = element_rect(fill = "transparent", color="transparent"),
      legend.title=element_text(size=1, color="transparent", face = "bold"),
      legend.background = element_rect(fill = "white", colour = "black"))  
g
ggsave(g, filename="koprädikativ.png", scale=1, width=39.78, height=26.59, units="cm")
