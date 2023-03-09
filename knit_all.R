# knit all and generate PDF thumbnails

f_inline <- pagedown::chrome_print("paged_inline.Rmd")
f_inline_static <- pagedown::chrome_print("paged_inline_static.Rmd")
f_external <- pagedown::chrome_print("paged_external.Rmd")


make_pdf_thumbnails <- function(f_pdf) {

   stopifnot(fs::is_file(f_pdf))

   f_png <- pdftools::pdf_convert(f_pdf, dpi = 20)

   imgs <- f_png |>
      magick::image_read() |>
      magick::image_border(color = "black", geometry = "1x1") |>
      magick::image_border(color = "white", geometry = "5x5")

   img_all <- imgs |>
      magick::image_append()

   fs::dir_create("doc")
   f_out <- paste0("doc/", fs::path_ext_remove(basename(f_pdf)), "_thumbs.png")

   magick::image_write(
      img_all,
      path = f_out
   )

   Sys.sleep(1)

   fs::file_delete(f_png)

   f_out

}

f_inline |> make_pdf_thumbnails()
f_inline_static |> make_pdf_thumbnails()
f_external |> make_pdf_thumbnails()
