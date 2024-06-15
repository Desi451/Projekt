# Wczytanie danych
data_to_encode <- read.csv2("data/intermediate_data/amino_with_pairs.csv")
aaindex1_encoding_matrix <- read.csv2("data/intermediate_data/encoding_matrix_aaindex1.csv")
aaindex2_encoding_matrix <- read.csv2("data/intermediate_data/aaindex2_encoding_matrix.csv", check.names = FALSE)
aaindex3_encoding_matrix <- read.csv2("data/intermediate_data/aaindex3_encoding_matrix.csv", check.names = FALSE)
aaindex23_encoding_matrix <- rbind(aaindex2_encoding_matrix, aaindex3_encoding_matrix)

# Inicializacja zakodowanej macierzy aminokwasów
coding_vector_length <- nrow(aaindex1_encoding_matrix)
number_of_aminoacids <- 6
encoded_aminoacids_df <- data.frame(matrix(nrow = 0, ncol = number_of_aminoacids * coding_vector_length))
for (i in 1:number_of_aminoacids) {
    for (j in 1:coding_vector_length) {
        col_name <- paste(as.character(i), ":", as.character(j), sep = "")
        colnames(encoded_aminoacids_df)[(i - 1) * coding_vector_length + j] <- col_name
    }
}
rm(i, j, col_name, number_of_aminoacids)

# Inicializacja zakodowanej macierzy par aminokwasów
coding_vector_pairs_length <- nrow(aaindex23_encoding_matrix)
number_of_aminoacids_pairs <- 5
encoded_aminoacids_pairs_df <- data.frame(matrix(nrow = 0, ncol = number_of_aminoacids_pairs * coding_vector_pairs_length))
for (i in 1:number_of_aminoacids_pairs) {
    for (j in 1:coding_vector_pairs_length) {
        col_name <- paste("p", as.character(i), ":", as.character(j), sep = "")
        colnames(encoded_aminoacids_pairs_df)[(i - 1) * coding_vector_pairs_length + j] <- col_name
    }
}
rm(i, j, col_name, number_of_aminoacids_pairs)

# Wypełnianie zakodowanej macierzy aminokwasów
encode_aminoacids <- FALSE
if (encode_aminoacids) {
    aminoacids_separated <- data_to_encode[, 2:7]
    for (i in seq_len(nrow(aminoacids_separated))) {
        print(i)
        for (j in seq_len(ncol(aminoacids_separated))) {
            beginning_of_insertion <- j * coding_vector_length - coding_vector_length + 1
            end_of_insertion <- j * coding_vector_length
            aminoacid_to_encode <- aminoacids_separated[i, j]
            encoded_aminoacids_df[i, beginning_of_insertion:end_of_insertion] <- unlist(aaindex1_encoding_matrix[ , aminoacid_to_encode])
        }
    }
    rm(i, j, beginning_of_insertion, end_of_insertion)
}

# Wypełnianie zakodowanej macierzy aminokwasów
encode_pairs <- TRUE
if (encode_pairs) {
    pairs_separated <- data_to_encode[, 8:12]
    for (i in seq_len(nrow(pairs_separated))) {
        print(i)
        for (j in seq_len(ncol(pairs_separated))) {
            beginning_of_insertion <- j * coding_vector_pairs_length - coding_vector_pairs_length + 1
            end_of_insertion <- j * coding_vector_pairs_length
            pair_to_encode <- pairs_separated[i, j]
            encoded_aminoacids_pairs_df[i, beginning_of_insertion:end_of_insertion] <- unlist(aaindex23_encoding_matrix[ , pair_to_encode])
        }
    }
    rm(i, j, beginning_of_insertion, end_of_insertion)
}