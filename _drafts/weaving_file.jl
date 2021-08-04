using Weave

# extract pathes and change the working directory
current_path = pwd()
file_path = current_path * "\\_drafts\\"

# print out the current directory and files
println(current_path)
println(readdir(file_path))

#===============================#
# specify the file to be weaved #
#===============================#
file_name = "2021-08-04-discretization-of-AR(1)-process-using-Adda-and-Cooper-(2003)"

# where to store results
markdown_path = current_path * "\\_posts"
figure_path = current_path * "\\assets\\figures"
file_Jmd = file_path * file_name * ".Jmd"

# start to weave Jmd to md and output them to the specified folders
weave(file_Jmd, doctype = "md2html", out_path = markdown_path, fig_path = figure_path, fig_ext = ".pdf")

# modify the figure path
markdown_file_path = markdown_path * "\\" * file_name * ".md"
figure_path_adjusted = replace(figure_path, "\\" => "/")
txt = read(markdown_file_path, String)
open(markdown_file_path, "w") do f
   write(f, replace(txt, figure_path_adjusted => "/assets/figures"))
end
