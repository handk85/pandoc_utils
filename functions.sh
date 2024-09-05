
BASE_DIR="$HOME/.pandoc_utils"

function generate_slide(){
  # Run the script with markdown input
  # For example:
  # $ ./generate_slide.sh lab4.md

  if [ ! -d "build" ]; then
    echo "Create build directory"
    mkdir build
  fi

  outname="build/${1%.*}"
  pandoc -s -t revealjs $1 -V theme=white -V slideNumber="'c/t'" \
    --metadata pagetitle="$outname slides" -o "$outname".html \
    --css="$BASE_DIR"/assets/custom.css --reference-location=section \
    --include-in-header="$BASE_DIR"/assets/additional_head.html

  if [ ! -L "build/assets" ]; then
    echo "create a symbolic link: build/assets";
    ln -s "$BASE_DIR"/assets build/assets
  fi

  if [ ! -L "build/imgs" ]; then
    echo "create a symbolic link: build/imgs";
    ln -s ../imgs build/imgs
  fi
}

function monitor_slide(){
  # The script detects changes in the markdown file and automatically re-generate html slides
  mkdir -p build
  cp -r imgs build/imgs

  fswatch *.md| while read -r file; 
    do 
      filename=$(basename "$file")
      outname="build/${filename%.*}"
      generate_slide $filename
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

function compile_md(){
  outname=${1%.*}
  pandoc -s --embed-resource -c "$BASE_DIR"/assets/github-markdown.css -f gfm -t html ${1} -o "$outname".html
}
