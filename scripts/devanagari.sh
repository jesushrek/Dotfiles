devnagari() {
    awk '{
        gsub(/0/, "०");
        gsub(/1/, "१");
        gsub(/2/, "२");
        gsub(/3/, "३");
        gsub(/4/, "४");
        gsub(/5/, "५");
        gsub(/6/, "६");
        gsub(/7/, "७");
        gsub(/8/, "८");
        gsub(/9/, "९");
        print
    }'
}

