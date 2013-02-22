#!/bin/bash

BWDIR="$1"

# base 03
grep -rl '#000000' "$BWDIR" | xargs sed -i 's/#000000/#002B36/g'

# base 02
grep -rl '#222222' "$BWDIR" | xargs sed -i 's/#222222/#073642/g'
grep -rl '#262729' "$BWDIR" | xargs sed -i 's/#222222/#073642/g'

# base 01
grep -rl '#47494D' "$BWDIR" | xargs sed -i 's/#47494D/#586E75/g'
grep -rl '#47494d' "$BWDIR" | xargs sed -i 's/#47494d/#586E75/g'
grep -rl '#4C4C4C' "$BWDIR" | xargs sed -i 's/#4C4C4C/#586E75/g'
grep -rl '#4c4c4c' "$BWDIR" | xargs sed -i 's/#4c4c4c/#586E75/g'

# base 00
grep -rl '#808080' "$BWDIR" | xargs sed -i 's/#808080/#657B83/g'

# base 0
grep -rl '#C0C0C0' "$BWDIR" | xargs sed -i 's/#C0C0C0/#839496/g'
grep -rl '#c0c0c0' "$BWDIR" | xargs sed -i 's/#c0c0c0/#839496/g'

# base 1
grep -rl '#DBDBDB' "$BWDIR" | xargs sed -i 's/#DBDBDB/#93A1A1/g'
grep -rl '#dbdbdb' "$BWDIR" | xargs sed -i 's/#dbdbdb/#93A1A1/g'
grep -rl '#DFDBD2' "$BWDIR" | xargs sed -i 's/#DFDBD2/#93A1A1/g'
grep -rl '#dfdbd2' "$BWDIR" | xargs sed -i 's/#dfdbd2/#93A1A1/g'

# base 2
grep -rl '#E0E0E0' "$BWDIR" | xargs sed -i 's/#E0E0E0/#EEE8D5/g'
grep -rl '#e0e0e0' "$BWDIR" | xargs sed -i 's/#e0e0e0/#EEE8D5/g'

# base 3
grep -rl '#F0F0F0' "$BWDIR" | xargs sed -i 's/#F0F0F0/#FDF6E3/g'
grep -rl '#f0f0f0' "$BWDIR" | xargs sed -i 's/#f0f0f0/#FDF6E3/g'
grep -rl '#F4F4F4' "$BWDIR" | xargs sed -i 's/#F4F4F4/#FDF6E3/g'
grep -rl '#f4f4f4' "$BWDIR" | xargs sed -i 's/#f4f4f4/#FDF6E3/g'
grep -rl '#FAFAFA' "$BWDIR" | xargs sed -i 's/#FAFAFA/#FDF6E3/g'
grep -rl '#fafafa' "$BWDIR" | xargs sed -i 's/#fafafa/#FDF6E3/g'
grep -rl '#FFFFFF' "$BWDIR" | xargs sed -i 's/#FFFFFF/#FDF6E3/g'
grep -rl '#ffffff' "$BWDIR" | xargs sed -i 's/#ffffff/#FDF6E3/g' 

# orange
grep -rl '#E04613' "$BWDIR" | xargs sed -i 's/#E04613/#CB4B16/g'
grep -rl '#e04613' "$BWDIR" | xargs sed -i 's/#e04613/#CB4B16/g'

# blue
grep -rl '#16778F' "$BWDIR" | xargs sed -i 's/#16778F/#268BD2/g'
grep -rl '#16778f' "$BWDIR" | xargs sed -i 's/#16778f/#268BD2/g' 
grep -rl '#3168A0' "$BWDIR" | xargs sed -i 's/#3168A0/#268BD2/g' 
grep -rl '#3168a0' "$BWDIR" | xargs sed -i 's/#3168a0/#268BD2/g'

# cyan
grep -rl '#6C9EAB' "$BWDIR" | xargs sed -i 's/#6C9EAB/#2AA198/g'
grep -rl '#6c9eab' "$BWDIR" | xargs sed -i 's/#6c9eab/#2AA198/g'
grep -rl '#90B1C0' "$BWDIR" | xargs sed -i 's/#90B1C0/#2AA198/g'
grep -rl '#90b1c0' "$BWDIR" | xargs sed -i 's/#90b1c0/#2AA198/g'
grep -rl '#8FB0BF' "$BWDIR" | xargs sed -i 's/#8fb0bf/#2AA198/g'
grep -rl '#8fb0bf' "$BWDIR" | xargs sed -i 's/#8fb0bf/#2AA198/g'

# yellow
grep -rl '#776C58' "$BWDIR" | xargs sed -i 's/#776C58/#B58900/g'
grep -rl '#776c58' "$BWDIR" | xargs sed -i 's/#776c58/#B58900/g'

# violet
grep -rl '#7F318D' "$BWDIR" | xargs sed -i 's/#7F318D/#6C71C4/g'
grep -rl '#7f318d' "$BWDIR" | xargs sed -i 's/#7f318d/#6C71C4/g'

