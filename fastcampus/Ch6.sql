SELECT * FROM tEmployee
SELECT * FROM tDepartment
SELECT * FROM tRank
SELECT * FROM tOrder
SELECT * FROM tItem
SELECT * FROM tReturn
SELECT * FROM tReturnReason
SELECT * FROM tProduction

# Chapter 6. P1
SELECT i.INumber 제품명, rr.RReason, r.RDate
FROM tReturn r
INNER JOIN tOrder o
        ON o.ONumber = r.ONumber
INNER JOIN tProduction p
        ON p.PNumber = o.PNumber
INNER JOIN tItem i
        ON i.INumber = p.INumber
INNER JOIN tReturnReason rr
        ON rr.RRNumber = r.RRNumber
ORDER BY i.INumber, r.RDate


# Chapter 6. P2
SELECT i.IName,
       sum(p.pCount) 판매량,
       COALESCE(SUM(r.RCount), 0) 반품량,
       COALESCE(
               ROUND(CAST(SUM(r.RCount) AS FLOAT) / CAST(sum(p.PCount) AS FLOAT) * 100, 2),
               0
           )
FROM tProduction p
INNER JOIN tOrder o
        ON o.PNumber = p.PNumber
INNER JOIN tItem i
        ON i.INumber = p.INumber
LEFT OUTER JOIN tReturn r
             ON r.ONumber = o.ONumber
GROUP BY I.IName
ORDER BY I.IName

# Chapter 6. P3
SELECT c.CAddr 지역명, COUNT(c.CAddr) '주문 횟수', RANK() OVER(Order by COUNT(c.CAddr) desc)
FROM tOrder o
INNER JOIN tCustomer c
        ON o.CNumber = c.CNumber
WHERE DATE_FORMAT(o.ODate, '%Y-%m') BETWEEN '2021-01' AND '2021-03'
GROUP BY c.CAddr

# Chapter 6. P4
SELECT SUB.INumber 분류코드, sub.IName 제품명
FROM (
    SELECT p.INumber, i.IName, RANK() OVER(PARTITION BY SUBSTR(i.INumber, 1, 2) ORDER BY COUNT(p.PNumber) DESC, i.INumber) as r
    FROM tProduction p
    INNER JOIN tOrder o
            ON o.PNumber = p.PNumber
    INNER JOIN tItem i
            ON i.INumber = p.INumber
    GROUP BY p.INumber
) SUB
WHERE sub.r = 1

# Chapter 6. P5
SELECT e.DNumber, e2.EName
FROM tEmployee e
INNER JOIN tEmployee e2
        ON e.DNumber = e2.DNumber
WHERE e.EName = '김효식' AND e2.EName != '김효식'

