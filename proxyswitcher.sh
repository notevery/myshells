# proxyswitcher -h
usage () {
  cat <<EOF
  usage: proxyswitcher [options]

  -h           optional  Print this help message
  --on FILE      optional  Log output in FILE
  -c CHECK     optional  Comma delimited list of specific check(s)
  -e CHECK     optional  Comma delimited list of specific check(s) to exclude
  -x EXCLUDE   optional  Comma delimited list of patterns within a container name to exclude from check
EOF
}

if  grep -q http_proxy /etc/profile ;then
    echo "代理有"
else
    echo "没有代理"
fi




case $USER in 
    root)
         echo "you are root" ;;
    *)
         echo "you are not root" 
esac

abspath () { 
    case "$1" in /*)printf "%s\n" "$1";;
      *)printf "%s\n" "$PWD/$1";;
    esac; }

abspath_path=$(abspath "$0")
echo "参数\$0: $0"
echo "全路径：$abspath_path"

myabs () {
   echo $(cd `dirname $1`; pwd)
   return 0
}
myabs_path=$(myabs "$0")
echo "参数\$0: $0"
echo "全路径： $myabs_path"

echo "mybashname: $(basename '/root/test.shs')"


while getopts hl:c:e:x: args
do
  case $args in
  h) usage; exit 0 ;;
  on) usage; exit 0 ;;
  l) logger="OPTARG" ;;
  c) check="OPTARG" ;;
  e) checkexclude="OPTARG" ;;
  x) exclude="OPTARG" ;;
  *) usage; exit 1 ;;
  esac
done

case $USER in
    root)
         echo "you are root" ;;
    *)
         echo "you are not root"
esac


