using Weave

# extract pathes and change the working directory
old_path = pwd()
new_path = old_path * "\\_drafts"
cd(new_path)

# print out the current directory and files
println(pwd())
println(readdir())

# where to store results
markdown_path = old_path * "\\_posts"
figure_path = old_path * "\\assets\\figures"
file_name = "2021-08-04-discretization-of-AR(1)-process-using-Adda-and-Cooper-(2003).Jmd"

# start to weave Jmd to md and output them to the specified folders
weave(file_name, doctype = "github", out_path = markdown_path, fig_path = figure_path)
