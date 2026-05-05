install.packages("DataExplorer")

library(tidyverse)
library(ggplot2)
library(DataExplorer)
library(caret)
library(dplyr)
library(corrplot)
library(readr)

data <- read_csv("C:/Users/HP/Downloads/datasetuas2(2).csv")
head(data)

# Cek struktur data
str(data)
summary(data)
glimpse(data)

# Cek baris duplikat
duplicated_rows <- duplicated(data)
# Tampilkan jumlah dan baris duplikat
cat("Jumlah baris duplikat:", sum(duplicated_rows), "\n")
# Lihat baris duplikat (jika ada)
data[duplicated_rows, ]

# Lihat missing values
sapply(data, function(x) sum(is.na(x)))
plot_missing(data)  # dari DataExplorer

# Outlier
# Hilangkan kolom non-numerik (seperti nama provinsi)
data_num <- data[sapply(data, is.numeric)]

# Fungsi untuk mendeteksi outlier berdasarkan IQR
detect_outliers <- function(x) {
  Q1 <- quantile(x, 0.25, na.rm = TRUE)
  Q3 <- quantile(x, 0.75, na.rm = TRUE)
  IQR_val <- Q3 - Q1
  lower <- Q1 - 1.5 * IQR_val
  upper <- Q3 + 1.5 * IQR_val
  return(x < lower | x > upper)
}

# Buat dataframe penanda outlier
outlier_flags <- as.data.frame(sapply(data_num, detect_outliers))
# Hitung jumlah outlier per kolom
outlier_summary <- colSums(outlier_flags)
print(outlier_summary)
ggplot(data, aes(y = Total_Wis)) +
  geom_boxplot(fill = "tomato") +
  theme_minimal() +
  labs(title = "Boxplot Total Wisatawan")

ggplot(data, aes(x = Longitude, y = Latitude)) +
  geom_point(aes(size = Total_Wis, color = Total_Wis), alpha = 0.7) +
  scale_color_gradient(low = "lightgreen", high = "darkgreen") +
  theme_minimal() +
  labs(title = "Sebaran Geografis Total Wisatawan", x = "Longitude", y = "Latitude")

# Ambil hanya kolom numerik
data_num <- data[sapply(data, is.numeric)]
# Hitung korelasi
corr <- cor(data_num, use = "complete.obs")
# Visualisasi heatmap korelasi
library(corrplot)
corrplot::corrplot(corr, method = "color", type = "upper", tl.cex = 0.7)

# Agregasi data bulanan
data_bulanan <- colSums(data[, grep("Wis_", names(data))])
# Konversi ke dataframe
df_bulanan <- data.frame(
  Bulan = factor(month.abb, levels = month.abb),
  Total = as.numeric(data_bulanan)
)
# Visualisasi
ggplot(df_bulanan, aes(x = Bulan, y = Total, group = 1)) +
  geom_line(color = "blue", size = 1.2) +
  geom_point(color = "blue", size = 3) +
  theme_minimal() +
  labs(title = "Total Wisatawan per Bulan (Nasional)")

# Model regresi
model <- lm(Total_Wis ~ Pengeluaran_Mikro + Dom_Datang, data = data)

# Residual
res <- resid(model)

# Histogram
hist(res, main = "Histogram Residual", xlab = "Residual")
# QQ Plot
qqnorm(res)
qqline(res, col = "blue")

# Uji Shapiro-Wilk
shapiro.test(res)

# Uji Multikolinearitas
library(car)
vif(model)

# Uji Homoskedastisitas
library(lmtest)
bptest(model)

# Uji Autokorelasi
dwtest(model)