SELECT s.Name,
       count(*)
FROM DivMst d,
     StudentMst s
WHERE d.StdName = s.Name
GROUP BY d.StdName
HAVING count(*) =
  (SELECT MAX (mycount)
   FROM
     (SELECT COUNT(*) mycount
      FROM DivMst
      GROUP BY StdName) a);