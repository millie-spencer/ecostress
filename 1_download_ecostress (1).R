library(httr)
library(jsonlite)
library(curl)
# Create a token by calling AppEEARS API login service. Update the “USERNAME” and “PASSEWORD” with yours below
secret <- base64_enc(paste("yourusername", "yourpassword", sep = ":"))
API_URL = 'https://appeears.earthdatacloud.nasa.gov/api/'

response <- httr::POST(paste0(API_URL,"login"), 
                       add_headers("Authorization" = paste("Basic", gsub("\n", "", secret)), 
                                   "Content-Type" = "application/x-www-form-urlencoded;charset=UTF-8"),
                       body = "grant_type=client_credentials")
response_content <- content(response)                          # Retrieve the content of the request
token_response <- toJSON(response_content, auto_unbox = TRUE)  # Convert the response to the JSON object
prettify(token_response)

s = new_handle()
handle_setheaders(s, 'Authorization'=paste("Bearer", fromJSON(token_response)$token))

url <- read.table("D:/NASA/Guatemala/Guatemala-ESI-0326-2-download-list.txt", header = F) #change here to your txt tile

for (d in 1:nrow(url)){
  name <- strsplit(url$V1[d],"/")[[1]][8]
  dest <- paste0("D:/NASA/Guatemala/ESI/",name)
  curl_download(url=url$V1[d], destfile=dest, handle = s)
  Sys.sleep(1)
  print(paste0("Downloading ", d, " out of ", nrow(url)))
}

