# uva 11291

https://onlinejudge.org/external/112/11291.pdf

``` 
p * (e1 + e2) + (1 - p) * (e1 - e2) 
```

grammar:
```
e[x] -> ( prob e[x] e[x] ) | NUMBER
prob -> NUMBER
```