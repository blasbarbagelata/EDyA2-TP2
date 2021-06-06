module ListSeq where

import Seq
import Par

instance Seq [] where
  emptyS = emptyS_
  singletonS = singletonS_
  lengthS = lengthS_
  nthS = nthS_
  tabulateS = tabulateS_
  mapS = mapS_
  filterS = filterS_
  appendS = appendS_
  takeS = takeS_
  dropS = dropS_
  showtS = showtS_
  showlS = showlS_
  joinS = joinS_
  reduceS = reduceS_
  scanS = scanS_
  fromList = fromList_

emptyS_ = []

singletonS_ a = [a]

lengthS_ s = length s

nthS_ s n = s !! n
 
tabulateS_ f n = tabulateS' f n 0 
                 where 
                  tabulateS' f 0 _ = emptyS_ 
                  tabulateS' f n i = let (x, xs) = f i ||| tabulateS' f (n-1) (i+1)
                                    in x:xs
  

mapS_ f [] = emptyS_ 
mapS_ f (x:xs) = let (y, ys) = f x ||| mapS_ f xs
                 in y:ys

filterS_ _ [] = emptyS_ 
filterS_ p (x:xs) = let (y, ys) = p x ||| filterS_ p xs
                    in if y then x : ys else ys 

appendS_ [] sb = sb
appendS_ sa [] = sa
appendS_ (a:sa) sb = a: (appendS_ sa sb)

takeS_ s n = take n s

dropS_ s n = drop n s

showtS_ [] = EMPTY
showtS_ [x] = ELT x
showtS_ xs = let largo = div (lengthS_ xs) 2
                 (l, r) = (takeS_ xs largo) ||| (dropS_ xs largo)
             in NODE l r

showlS_ [] = NIL
showlS_ (x:xs) = CONS x xs

joinS_ [] = emptyS_ 
joinS_ (x:xs) = appendS_ x (joinS_ xs)

contraer :: (a -> a -> a) -> [a] -> [a]
contraer _ [] = emptyS_
contraer _ [x] = singletonS_ x
contraer f (x:y:xs) = let (z,zs) = f x y ||| contraer f xs
                      in z:zs

reduceS_ _ e [] = e
reduceS_ f e [x] = f e x
reduceS_ f e xs = reduceS_ f e (contraer f xs)

scanS_ _ e [] = (emptyS_ , e)
scanS_ f e [x] = (singletonS_ e, f e x)
scanS_ f e xs = let (ys, r) = scanS_ f e (contraer f xs)
                in (expandirSeq f xs ys, r) 
                where
                  expandirSeq _ [] _ = []
                  expandirSeq _ [_] [y] = [y]
                  expandirSeq f (x:_:xs) (y:ys) = let (z, zs) = (f y x) ||| expandirSeq f xs ys in y : z : zs
fromList_ s = s 