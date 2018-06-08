
# Arbeitsverzeichnis definieren
setwd("C:/Users/yvessche/OneDrive - University of Helsinki/teaching/18-geoling-lmu/handson")

##########################################################################

### 1 - Polygonkarte laden und darstellen

library(ggplot2)
library(raster)


# Geodaten laden
fr_dept = getData("GADM", country="France", level=2)
fr_dept = spTransform(fr_dept, CRS("+proj=longlat +datum=WGS84"))
head(fr_dept@data)


# Folgende Zeilen sind nötig, um das Shapefile in einen Dataframe umzuwandeln
# (mit ggmap können nur Dataframes gezeichnet werden):
fr_dept@data$objid = rownames(fr_dept@data)   # eine zusätzliche Spalte "objid" hinzufügen
fr_dept.df = fortify(fr_dept)   # shapefile in dataframe umwandeln, dabei gehen Attribute verloren
fr_dept.df = merge(fr_dept.df,fr_dept@data, by.x="id", by.y="objid")  # Attribute vom Shapefile zurückholen
head(fr_dept.df)

# Darstellung: Polygongrenzen blau
ggplot() +
  geom_polygon(data=fr_dept.df, aes(x=long, y=lat, group=group), color="blue", size=0.4) + 
  coord_map()


### 2 - Attribute laden und mit Polygonen verknüpfen


head(fr_dept.df)
# der zweistellige Departements-Code ist in Feld CCA_2

# Attribute laden
peguer_attr = read.table("data/peguer_dept.txt", header=T, sep="\t", quote="", dec=".")
head(peguer_attr)
# der zweistellige Departements-Code ist in Feld DEPT

# Geodaten mit Attributen verbinden ("inner join" in Datenbank-Terminologie)
fr_joined = merge(x=fr_dept.df, y=peguer_attr, by.x="CCA_2", by.y="DEPT")
head(fr_joined)

# Darstellung: Polygonfüllung nach PEGUER-Wert, Polygongrenzen transparent
ggplot() +
  geom_polygon(data=fr_joined, aes(x=long, y=lat, group=group, fill=PEGUER), color="transparent", size=0.4) + 
  coord_map()


### 3 - Kartenhintergrund mit ggmap hinzufügen

library(ggmap)

# die Koordinaten können vom vorherigen Plot abgelesen werden
fr = c(left=-6, right=10, top=51.5, bottom=40.5)
backgr = get_stamenmap(fr, maptype="terrain-background", color="bw", zoom = 6)

# anstatt ggplot() nehmen wir nun ggmap() mit dem Hintergrundbild
ggmap(backgr) +
  geom_polygon(data=fr_joined, aes(x=long, y=lat, group=group, fill=PEGUER), color="transparent", size=0.4) + 
  coord_map()


### 4 - Kosmetische Verbesserungen

library(scales)

# geom_label: Kartentitel
# alpha=0.7: Polygone werden halbtransparent, Hintergrund scheint durch
# palette="RdBu": Klassischer Heat-Map-Farbverlauf (siehe http://colorbrewer2.org)
# breaks=pretty_breaks(n=10): teilt die Daten automatisch in 10 Farbklassen ein
# labels=percent: fügt Prozentzeichen in die Legende ein
# theme: Position und Formatierung der Legende und Achsen
g = ggmap(backgr) +
  geom_label(aes(x = -3.5, y = 50.8, label = "péguer"), size=8, fill = "transparent", color="black", alpha=1) +
  geom_polygon(data=fr_joined, aes(x=long, y=lat, group=group, fill=PEGUER), alpha=0.7, color="transparent", size=0.4) + 
  coord_map() +
  scale_fill_distiller(palette="RdBu", breaks=pretty_breaks(n=10), labels=percent) + 
  theme(legend.justification=c(0,0),
      axis.title.x=element_blank(),
      axis.text.x=element_blank(),
      axis.ticks.x=element_blank(),
      axis.title.y=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks.y=element_blank(),
      legend.position=c(0.02,0.02),
      legend.spacing=unit(1,"lines"),
      legend.box="vertical",
      legend.key.size=unit(1.2,"lines"),
      legend.key.height=unit(2,"line"),
      legend.text.align=0,
      legend.title.align=0,
      legend.text=element_text(size=12, color="black"),
      legend.key = element_rect(fill = "transparent", color="transparent"),
      legend.title=element_text(size=1, color="transparent", face = "bold"),
      legend.background = element_rect(fill = "white", colour = "transparent"))  
g

# Speicherung
# Achtung: Legenden werden u.U. anders dargestellt als in der Vorschau!
ggsave(g, filename="peguer.png", scale=1, width=39.78, height=26.59, units="cm")
