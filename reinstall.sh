
trap 'echo Got SIGINT, ignoring.' 2

#Paths and Filename-Definitions

#In-Memory Databases
declare -A deps_indb
declare -A expl_indb
deps_worklist=()
expl_worklist=()

echo 'Init completed.'

echo "Calculating worklist..."
tmp1=""
tmp2=""
echo "  Depency-packages..."
oldifs="$IFS"
IFS=$'\n'
for e in `yaourt -Qdn`; do
  tmp1=$(echo $e | cut -d' ' -f1)
  tmp2=$(echo $e | cut -d' ' -f2)
  if [ ! -z "$tmp1" -a ! -z "$tmp2" ]; then
    deps_worklist+=("$tmp1")
  fi
done
tmp1=""
tmp2=""
echo "  Explicit-packages..."
for e in `yaourt -Qen`; do
  tmp1=$(echo $e | cut -d' ' -f1)
  tmp2=$(echo $e | cut -d' ' -f2)
  if [ ! -z "$tmp1" -a ! -z "$tmp2" ]; then
    expl_worklist+=("$tmp1")
  fi
done
IFS="$oldifs"
unset tmp1 tmp2 e

echo "Reinstalling packages..."
tmp1=""
tmp2=""
echo "  Depency-Packages"
for e in "${deps_worklist[@]}"; do
  echo "   Package: '$e'"
  yaourt -S $e --asdeps --force --noconfirm > /dev/null 2>&1
  if test $? -ne 0; then
    echo "Warning: Package '$e' could not be reinstalled"
  fi
done
unset deps_worklist

tmp1=""
echo "  Explicit-Packages"
for e in "${expl_worklist[@]}"; do
  echo "   Package: $e"
  yaourt -S $e --asexplicit --force --noconfirm > /dev/null 2>&1
  if test $? -ne 0; then
    echo "Warning: Package '$e' could not be reinstalled"
  fi
done

unset tmp1 tmp2 expl_worklist
