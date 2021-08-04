using Weave

# extract pathes and change the working directory
current_path = pwd()
file_path = current_path * "\\_drafts\\"

# print out the current directory and files
println(current_path)
println(readdir(file_path))

# where to store results
markdown_path = current_path * "\\_posts"
figure_path = current_path * "\\assets\\figures"
file_name = file_path * "2021-08-04-discretization-of-AR(1)-process-using-Adda-and-Cooper-(2003).Jmd"

# start to weave Jmd to md and output them to the specified folders
weave(file_name, doctype = "github", out_path = markdown_path, fig_path = figure_path)

filenames = ["f1.txt", "f2.txt"]
for filename in filenames
   txt = read(filename, String)
   open(filename, "w") do f
      write(f, replace(txt, "Goodbye London!" => "Hello New York!"))
   end
end
