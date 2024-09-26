
BASE_DIR="$HOME/.pandoc_utils"

function init_build_structure(){
  if [ ! -d "build" ]; then
    echo "Create build directory"
    mkdir build
  fi
  if [ ! -L "assets" ]; then
    echo "Create a symbolic link: assets";
    ln -s "$BASE_DIR"/assets
  fi
  if [ -d "imgs" ] && [ ! -L "build/imgs" ]; then
      echo "Create a symbolic link: build/imgs";
      ln -s ../imgs build/imgs
  fi
}

function compile_slide(){
  # Run the script with markdown input
  # For example:
  # $ ./generate_slide.sh lab4.md

  init_build_structure

  outname="build/${1%.*}"
  pandoc -s -t revealjs $1 -V theme=white -V slideNumber="'c/t'" \
    --metadata pagetitle="$outname slides" -o "$outname".html \
    --css="$BASE_DIR"/assets/custom.css --reference-location=section \
    --include-in-header="$BASE_DIR"/assets/additional_head.html\
    --embed-resources \
    -V revealjs-url="$BASE_DIR/assets/js/reveal.js" \

  if [ ! -L "build/imgs" ]; then
    echo "create a symbolic link: build/imgs";
    ln -s ../imgs build/imgs
  fi
}

function monitor_slide(){
  fswatch *.md| while read -r file; 
    do 
      filename=$(basename "$file")
      outname="build/${filename%.*}"
      compile_slide $filename
      echo "$(date "+%H:%M:%S") $outname.html has been updated"
    done
}

function generate_dist(){
  mkdir -p dist

  for file in build/*.html; 
  do
    echo "$file"
    inliner --nosvg --skip-absolute-urls "$file" > "dist/$(basename "$file")" 
  done
}

function md_to_html(){
  init_build_structure

  outname="build/${1%.*}"
  pandoc -s --embed-resource -c "$BASE_DIR"/assets/github-markdown.css -f gfm -t html ${1} -o "$outname".html \
    --include-in-header="$BASE_DIR"/assets/additional_head.html
}

function monitor_md(){
  fswatch *.md | while read -r file;
    do
      filename=$(basename "$file")
      outname="build/${filename%.*}"
      md_to_html $filename
      echo "$(date "+%H:%M:%S") $outname.html has been updated"
    done
}
