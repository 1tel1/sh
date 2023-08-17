mcd ()
{
  mkdir -p -- "$1" && cd -P -- "$1"
}

cls ()
{
  cd "$1" && ls
}
