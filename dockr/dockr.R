library(dockr)

package_dir <- system.file(package = "dockr")

image_dockr <- prepare_docker_image(pkg = package_dir, 
                                    dir_image = "/Users/macbook/Desktop/dockr",
                                    dir_install="/Users/macbook/Desktop/dockr")

list.files(image_dockr$paths$dir_image)

list.files(image_dockr$paths$dir_source_packages)

# write lines to the end of the file.
write_lines_to_file(c("# Write lines next."),
                    image_dockr$paths$path_Dockerfile,
                    prepend = FALSE,
                    print_file = FALSE)

