library(tidyr)

# Funkcja do przetwarzania danych
process_data <- function(input_file_name, output_file_path) {
    # Wczytanie danych
    input_data <- read.csv(input_file_name, header = FALSE)

    # Konwersja danych wejściowych do odpowiedniego formatu
    input_data$V21 <- NULL
    row_indexes_to_remove <- seq(from = 1, to = 988, by = 21)
    input_data <- input_data[-row_indexes_to_remove, ]
    rownames(input_data) <- NULL

    # Generacja i zmiana nazw kolumn tabeli wyjściowej
    aminoacid_names <- c("a", "r", "n", "d", "c", "q", "e", "g", "h", "i", "l", "k", "m", "f", "p", "s", "t", "w", "y", "v")
    col_names <- c()
    for (i in aminoacid_names) {
        for (j in aminoacid_names) {
            col_names <- c(col_names, sprintf("%s%s", j, i))
        }
    }
    output_data <- data.frame(matrix(nrow = 0, ncol = length(col_names)))
    colnames(output_data) <- col_names

    # Wypełnienie macierzy kodowania na podstawie danych wejściowych
    output_data_row_count <- 0
    output_data_col_count <- 0
    for (i in 1:nrow(input_data)) {
        if (i %% 20 == 1) {
            output_data_row_count <- output_data_row_count + 1
            output_data_col_count <- 0
        }
        for (j in 1:ncol(input_data)) {
            output_data_col_count <- output_data_col_count + 1
            output_data[output_data_row_count, output_data_col_count] <- input_data[i, j]
        }
    }

    # Kopiowanie danych dla indeksów z "lustrzanymi odbiciami"
    for (i in 1:nrow(output_data)) {
        for (j in 1:ncol(output_data)) {
            if (is.na(output_data[i, j])) {
                name_vec <- unlist(strsplit(colnames(output_data)[j], ""))
                col_name_to_search <- sprintf("%s%s", name_vec[2], name_vec[1])
                data_to_copy <- output_data[i, col_name_to_search]
                output_data[i, j] <- data_to_copy
            }
        }
    }

    # Usunięcie indexów z brakującymi danymi
    output_data <- drop_na(output_data)

    # Zapis do pliku
    write.table(output_data, file = output_file_path, sep = ";", row.names = FALSE, col.names = TRUE, quote = FALSE)
}

# Przetwarzanie danych dla plików aaindex2 i aaindex3
process_data("data/intermediate_data/extracted_values_aaindex2.csv", "data/intermediate_data/aaindex2_encoding_matrix.csv")
process_data("data/intermediate_data/extracted_values_aaindex3.csv", "data/intermediate_data/aaindex3_encoding_matrix.csv")
