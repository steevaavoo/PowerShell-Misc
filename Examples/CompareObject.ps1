$array1 = 'Steve', 'Adam', 'Paul', 'Phil'
$array2 = 'Nick', 'Adam', 'Paul', 'Ringo'

Compare-Object -ReferenceObject $array1 -DifferenceObject $array2 -IncludeEqual | Where-Object SideIndicator -eq '=>'