# Installation der benötigten Packages (einmal installieren genügt)

# sp: Funktionen für Geodaten
install.packages("sp")

# raster: direktes Herunterladen von Geodaten
install.packages("raster")

# rgdal: Interface für die GDAL-Bibliothek (Shapefiles)
install.packages("rgdal")

# ggplot2: Bibliothek für grafische Darstellungen
install.packages("ggplot2")

# ggmap: direktes Herunterladen von Hintergrunddaten
install.packages("ggmap")

# ggrepel: automatische Plazierung von Legenden
install.packages("ggrepel")

# rgeos: Interface für die GEOS-Bibliothek
install.packages("rgeos")

# maptools: Alternatives Interface für Shapefiles
install.packages("maptools")

# Cairo: Export als Bilddatei oder PDF
install.packages("Cairo")

# Scales: Klassifizierung von Ordinaldaten
install.packages("scales")

# deldir: Voronoi-Diagramme
install.packages("deldir")

#########################

# Falls ggmap/ggplot2 nicht wie erwünscht funktioniert, muss die aktuelle Version des Packages
# folgendermassen direkt installiert werden (Kommentare entfernen):

# install.packages("devtools")
# devtools::install_github("dkahle/ggmap")
# devtools::install_github("hadley/ggplot2")
