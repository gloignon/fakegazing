# simulation.R
# va dans le projet eyetracking
# 
# simule des données oculo à partir d'un csv contenant les position et les timings des cibles dans
# une vidéo de référence
#
# printemps 2020

library(tidyverse)
library("data.table")

dt.positions_simul <-
  read_csv("datafiles/positions_simul_v5.csv") %>% data.table()

# généré par le script Python de pré-traitement pour les simulations
#dt.vid_timestamps <- read_delim("datafiles/sim_frame_timestamps.tsv", 
#                            "\t", escape_double = FALSE, trim_ws = TRUE) %>% data.table()
#colnames(dt.vid_timestamps) <- c("vid_frameNum", "vid_ts")

n_diapos <- 22
duree_diapo_ms <- 1000  # duree en ms d'une diapo
reso_x <- 1920
reso_y <- 1080
sampling_rate <- 50
video_rate <- 25  # en hz

duree_video_s <- n_diapos * (duree_diapo_ms / 1000)
duree_frame <- (1 / video_rate) * 1000
duree_sample <- (1 / sampling_rate) * 1000
n_sample_diapo <- duree_diapo_ms / duree_sample
n_frame_diapo <- duree_diapo_ms / duree_frame
n_vid_frame <- n_diapos * (duree_diapo_ms / 1000) * video_rate
n_samples <- duree_video_s * sampling_rate
last_ts <- (n_samples - 1) * duree_sample

#dt.positions_simul[,  := ((id_image -1) * n_frame_diapo)]

# on créée le fichier normalement produit par Python (analyse des frames de la vidéo)
dt.vid_timestamps <- data.table(vid_frameNum = 0:(n_vid_frame-1))

# attache une colonne pivot
#dt.vid_timestamps[, frame_debut := floor(vid_frameNum / n_frame_diapo) * n_frame_diapo]
dt.vid_timestamps[, id_image := floor(vid_frameNum / n_frame_diapo) + 1]

# données de simulation
dt.simul <- data.table(frame_idx = rep(0:(n_vid_frame - 1), each = 2),# c'est l'id du video frame
                       timestamp = seq(0, last_ts, by=duree_sample))

# dt.ts va contenir les timestamps, frame_id et autres identifiants
dt.ts <-
  merge(
    dt.vid_timestamps,
    dt.simul,
    all = TRUE,
    by.x = "vid_frameNum",
    by.y = "frame_idx"
  )[order(timestamp)]

# gérer l'alternance entre les deux cibles visuelles
dt.ts[, zone := rep(1:2, (nrow(dt.ts) / 50 ), each = 25 )]  # 20; 10 marche, 10; 5
table(dt.ts$zone, dt.ts$id_image)

# on ajoute enfin les coordonnées des cibles
dt.ts.coor <-
  merge(
    dt.ts,
    dt.positions_simul,
    by = c("id_image", "zone"),
    all = TRUE
  )[order(timestamp)]

dt.simul.propre <- dt.ts.coor[, .(
  idSample = 1:.N,
  timestamp = timestamp,
  frame_idx = vid_frameNum,
  confidence = 1,
  norm_pos_x = pos_x / reso_x,
  norm_pos_y = pos_y / reso_y,
  target_x = pos_x,
  target_y = pos_y,
  slide = id_image,
  zone
)]

#dt.simul.propre <- dt.simul.propre[!is.na(timestamp)]

save(dt.ts.coor, file = "./datafiles/dt_ts_coord.Rda")
# Écriture...
write.table(
  dt.simul.propre,
  sep= "\t",
  file = "./datafiles/gazeData_world.tsv",
  row.names = FALSE,
  quote = FALSE
)