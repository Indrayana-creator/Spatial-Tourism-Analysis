## Repository Structure

* **`data/`**: Berisi dataset utama (`datasetuas2(2).csv`) yang mencakup metrik pariwisata, mobilitas, dan pengeluaran per provinsi.
* **`scripts/`**: 
    * `01_eda_preprocessing.R`: Script untuk pra-pemrosesan data, deteksi outlier, analisis korelasi, dan Exploratory Data Analysis (EDA).
* **`notebooks/`**: 
    * `spatial_modeling.Rmd`: R Markdown utama (All-in-One) yang berisi eksekusi keseluruhan pemodelan regresi spasial (GWR, GWLR, GWPR, MGWR, GWNBR) beserta visualisasi koefisien lokal menggunakan `sf` dan `tmap`.
* **`output/`**: File diagnostik hasil run software GWR4 (`test_summary.txt`, `test.ctl`).