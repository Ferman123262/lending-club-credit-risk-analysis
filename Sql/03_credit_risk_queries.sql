CREATE TABLE lc_loans (
    id                      NUMBER(12)      PRIMARY KEY,
    loan_amnt               NUMBER(10,2),
    term                    NUMBER(3),
    int_rate                NUMBER(6,2),
    installment             NUMBER(10,2),
    grade                   VARCHAR2(2),
    sub_grade               VARCHAR2(3),
    issue_d                 DATE,
    purpose                 VARCHAR2(30),
    home_ownership          VARCHAR2(20),
    annual_inc              NUMBER(12,2),
    verification_status     VARCHAR2(30),
    addr_state              VARCHAR2(2),
    dti                     NUMBER(10,2),
    earliest_cr_line        DATE,
    delinq_2yrs             NUMBER(8,2),
    inq_last_6mths          NUMBER(8,2),
    open_acc                NUMBER(8,2),
    pub_rec                 NUMBER(8,2),
    revol_bal               NUMBER(14,2),
    revol_util              NUMBER(8,2),
    total_acc               NUMBER(8,2),
    mort_acc                NUMBER(8,2),
    pub_rec_bankruptcies    NUMBER(8,2),
    loan_status             VARCHAR2(60),
    total_pymnt             NUMBER(14,4),
    total_rec_prncp         NUMBER(14,4),
    recoveries              NUMBER(14,4),
    is_default              NUMBER(1),
    issue_year              NUMBER(4),
    credit_history_years    NUMBER(10,4),
    emp_length_num          NUMBER(6,2),
    fico_avg                NUMBER(8,2),
    loan_to_income          NUMBER(14,4),
    installment_to_income   NUMBER(14,4),
    unpaid_principal        NUMBER(14,4),
    net_loss                NUMBER(14,4),
    profit                  NUMBER(14,4)
);



select *  from lc_loans
fetch first 5 rows only;




-- 1. Portfelin əsas göstəriciləri nədir?
SELECT COUNT(*) loans,
       ROUND(SUM(loan_amnt)/1e6,1) volume_mln,
       ROUND(AVG(loan_amnt)) avg_loan,
       ROUND(AVG(int_rate),2) avg_rate,
       SUM(is_default) defaults,
       ROUND(AVG(is_default)*100,2) default_rate_pct,
       ROUND(SUM(net_loss)/1e6,1) loss_mln,
       ROUND(SUM(net_loss)/SUM(loan_amnt)*100,2) loss_rate_pct
FROM lc_loans;

-- 2. İllər üzrə kredit sayı, həcm və orta faiz necə dəyişib?
SELECT issue_year, COUNT(*) loans,
       ROUND(SUM(loan_amnt)/1e6,1) volume_mln,
       ROUND(AVG(loan_amnt)) avg_loan,
       ROUND(AVG(int_rate),2) avg_rate
FROM lc_loans GROUP BY issue_year ORDER BY issue_year;

-- 3. 36 aylıq və 60 aylıq kreditlərin portfeldə payı nə qədərdir?
SELECT term, COUNT(*) loans,
       ROUND(RATIO_TO_REPORT(COUNT(*)) OVER ()*100,1) loans_share_pct,
       ROUND(SUM(loan_amnt)/1e6,1) volume_mln,
       ROUND(AVG(int_rate),2) avg_rate
FROM lc_loans GROUP BY term ORDER BY term;

-- 4. Portfel grade-lər üzrə necə paylanıb?
SELECT grade, COUNT(*) loans,
       ROUND(RATIO_TO_REPORT(COUNT(*)) OVER ()*100,1) loans_share_pct,
       ROUND(RATIO_TO_REPORT(SUM(loan_amnt)) OVER ()*100,1) volume_share_pct
FROM lc_loans GROUP BY grade ORDER BY grade;

-- 5. Kreditlərin statusu üzrə paylanma necədir?
SELECT loan_status, COUNT(*) loans,
       ROUND(RATIO_TO_REPORT(COUNT(*)) OVER ()*100,2) share_pct
FROM lc_loans GROUP BY loan_status ORDER BY loans DESC;

-- 6. Kredit məbləği və gəlirin paylanması necədir (orta, median, uc qiymətlər)?
SELECT ROUND(AVG(loan_amnt)) avg_loan,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY loan_amnt) median_loan,
       PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY loan_amnt) p90_loan,
       MIN(loan_amnt) min_loan, MAX(loan_amnt) max_loan,
       ROUND(AVG(annual_inc)) avg_income,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY annual_inc) median_income
FROM lc_loans;

-- 7. Ən böyük itki yaradan 10 kredit hansılardır?
SELECT id, issue_year, grade, term, purpose, addr_state,
       loan_amnt, int_rate, ROUND(net_loss) net_loss
FROM lc_loans
ORDER BY net_loss DESC, id
FETCH FIRST 10 ROWS ONLY;

-- 8. Kredit məqsədləri üzrə portfelin payı nə qədərdir?
SELECT purpose, COUNT(*) loans,
       ROUND(SUM(loan_amnt)/1e6,1) volume_mln,
       ROUND(RATIO_TO_REPORT(SUM(loan_amnt)) OVER ()*100,1) volume_share_pct
FROM lc_loans GROUP BY purpose ORDER BY volume_mln DESC;


-- 9. Hansı grade ən riskli?
SELECT grade, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct,
       ROUND(AVG(int_rate),2) avg_rate
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY grade ORDER BY grade;

--evvelde qeyd etdiyim kimi  20099 ve 2015  arasi kreditlerin coxoxu baglanib ona gore filtirledik

-- 10. Sub-grade səviyyəsində risk necə artır (A1-dən G5-ə)?
SELECT sub_grade, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct,
       ROUND(AVG(int_rate),2) avg_rate
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY sub_grade ORDER BY sub_grade;

-- 11. 60 aylıq kreditlər 36 aylıqdan nə qədər riskli?
SELECT term, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct,
       ROUND(AVG(int_rate),2) avg_rate
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY term ORDER BY term;

-- 12. Hansı kredit məqsədi ən riskli?
SELECT purpose, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY purpose ORDER BY default_rate_pct DESC;

-- 13. Ev mülkiyyəti statusu riskə təsir edirmi?
SELECT home_ownership, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY home_ownership HAVING COUNT(*) >= 1000
ORDER BY default_rate_pct DESC;

-- 14. Gəlirin yoxlanılması riski azaldırmı?
SELECT verification_status, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct,
       ROUND(AVG(int_rate),2) avg_rate
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY verification_status ORDER BY default_rate_pct DESC;

-- 15. Ən riskli 10 ştat hansılardır (ən azı 5000 kredit)?
SELECT addr_state, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY addr_state HAVING COUNT(*) >= 5000
ORDER BY default_rate_pct DESC FETCH FIRST 10 ROWS ONLY;

-- 16. Ən təhlükəsiz 10 ştat hansılardır?
SELECT addr_state, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY addr_state HAVING COUNT(*) >= 5000
ORDER BY default_rate_pct ASC FETCH FIRST 10 ROWS ONLY;

-- 17. İş stajı riskə necə təsir edir?
SELECT emp_length_num, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY emp_length_num ORDER BY emp_length_num;

-- 18. Gəlir seqmentləri üzrə risk necədir?
SELECT income_band, COUNT(*) loans, ROUND(AVG(is_default)*100,2) default_rate_pct
FROM (SELECT is_default,
             CASE WHEN annual_inc < 30000 THEN '1) <30k'
                  WHEN annual_inc < 50000 THEN '2) 30-50k'
                  WHEN annual_inc < 75000 THEN '3) 50-75k'
                  WHEN annual_inc < 100000 THEN '4) 75-100k'
                  WHEN annual_inc < 150000 THEN '5) 100-150k'
                  ELSE '6) 150k+' END income_band
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY income_band ORDER BY income_band;

-- 19. DTI (borc/gəlir) səviyyəsi riskə necə təsir edir?
SELECT dti_band, COUNT(*) loans, ROUND(AVG(is_default)*100,2) default_rate_pct
FROM (SELECT is_default,
             CASE WHEN dti <= 10 THEN '1) 0-10'
                  WHEN dti <= 20 THEN '2) 10-20'
                  WHEN dti <= 30 THEN '3) 20-30'
                  WHEN dti <= 40 THEN '4) 30-40'
                  ELSE '5) 40+' END dti_band
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY dti_band ORDER BY dti_band;

-- 20. FICO skoru üzrə risk necədir?
SELECT fico_band, COUNT(*) loans, ROUND(AVG(is_default)*100,2) default_rate_pct
FROM (SELECT is_default,
             CASE WHEN fico_avg < 660 THEN '1) <660'
                  WHEN fico_avg < 700 THEN '2) 660-700'
                  WHEN fico_avg < 740 THEN '3) 700-740'
                  WHEN fico_avg < 780 THEN '4) 740-780'
                  ELSE '5) 780+' END fico_band
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY fico_band ORDER BY fico_band;

-- 21. Kredit məbləği artdıqca risk artırmı?
SELECT loan_band, COUNT(*) loans, ROUND(AVG(is_default)*100,2) default_rate_pct
FROM (SELECT is_default,
             CASE WHEN loan_amnt < 5000 THEN '1) <5k'
                  WHEN loan_amnt < 10000 THEN '2) 5-10k'
                  WHEN loan_amnt < 15000 THEN '3) 10-15k'
                  WHEN loan_amnt < 20000 THEN '4) 15-20k'
                  WHEN loan_amnt < 30000 THEN '5) 20-30k'
                  ELSE '6) 30k+' END loan_band
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY loan_band ORDER BY loan_band;

-- 22. Faiz dərəcəsi aralıqları üzrə default rate nədir?
SELECT rate_band, COUNT(*) loans, ROUND(AVG(is_default)*100,2) default_rate_pct
FROM (SELECT is_default,
             CASE WHEN int_rate < 8 THEN '1) <8%'
                  WHEN int_rate < 12 THEN '2) 8-12%'
                  WHEN int_rate < 16 THEN '3) 12-16%'
                  WHEN int_rate < 20 THEN '4) 16-20%'
                  ELSE '5) 20%+' END rate_band
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY rate_band ORDER BY rate_band;

-- 23. Grade və müddət birlikdə riski necə dəyişir?
SELECT grade, term, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY grade, term ORDER BY grade, term;

-- 24. FICO və DTI birgə riski necə formalaşdırır? (matris)
SELECT fico_band,
       ROUND(AVG(CASE WHEN dti_band='1) 0-10'  THEN is_default END)*100,1) dti_0_10,
       ROUND(AVG(CASE WHEN dti_band='2) 10-20' THEN is_default END)*100,1) dti_10_20,
       ROUND(AVG(CASE WHEN dti_band='3) 20-30' THEN is_default END)*100,1) dti_20_30,
       ROUND(AVG(CASE WHEN dti_band='4) 30+'   THEN is_default END)*100,1) dti_30_plus
FROM (SELECT is_default,
             CASE WHEN fico_avg < 660 THEN '1) <660'
                  WHEN fico_avg < 700 THEN '2) 660-700'
                  WHEN fico_avg < 740 THEN '3) 700-740'
                  ELSE '4) 740+' END fico_band,
             CASE WHEN dti <= 10 THEN '1) 0-10'
                  WHEN dti <= 20 THEN '2) 10-20'
                  WHEN dti <= 30 THEN '3) 20-30'
                  ELSE '4) 30+' END dti_band
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY fico_band ORDER BY fico_band;


-- 25. İllər üzrə default rate necə dəyişib (yetkin illər)?
SELECT issue_year, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY issue_year ORDER BY issue_year;

-- 26. İl və müddət üzrə default rate necədir?
SELECT issue_year,
       ROUND(AVG(CASE WHEN term=36 THEN is_default END)*100,2) dr_36m,
       ROUND(AVG(CASE WHEN term=60 THEN is_default END)*100,2) dr_60m
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY issue_year ORDER BY issue_year;

-- 27. Grade × il vintage matrisi: hansı grade hansı ildə pisləşib?
SELECT grade,
       ROUND(AVG(CASE WHEN issue_year=2009 THEN is_default END)*100,1) y2009,
       ROUND(AVG(CASE WHEN issue_year=2010 THEN is_default END)*100,1) y2010,
       ROUND(AVG(CASE WHEN issue_year=2011 THEN is_default END)*100,1) y2011,
       ROUND(AVG(CASE WHEN issue_year=2012 THEN is_default END)*100,1) y2012,
       ROUND(AVG(CASE WHEN issue_year=2013 THEN is_default END)*100,1) y2013,
       ROUND(AVG(CASE WHEN issue_year=2014 THEN is_default END)*100,1) y2014,
       ROUND(AVG(CASE WHEN issue_year=2015 THEN is_default END)*100,1) y2015
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY grade ORDER BY grade;

-- 28. Aylıq kredit həcmi necə dəyişib?
SELECT TRUNC(issue_d,'MM') month_start, COUNT(*) loans,
       ROUND(SUM(loan_amnt)/1e6,2) volume_mln
FROM lc_loans GROUP BY TRUNC(issue_d,'MM') ORDER BY month_start;

-- 29. Aylıq default rate və 3 aylıq hərəkətli orta
SELECT month_start, loans, default_rate_pct,
       ROUND(AVG(default_rate_pct) OVER (ORDER BY month_start
             ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) dr_3m_avg
FROM (SELECT TRUNC(issue_d,'MM') month_start, COUNT(*) loans,
             ROUND(AVG(is_default)*100,2) default_rate_pct
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
      GROUP BY TRUNC(issue_d,'MM'))
ORDER BY month_start;

-- 30. Kredit həcmi ildən-ilə neçə faiz artıb?
SELECT issue_year, volume_mln,
       ROUND((volume_mln / LAG(volume_mln) OVER (ORDER BY issue_year) - 1)*100,1) yoy_growth_pct
FROM (SELECT issue_year, ROUND(SUM(loan_amnt)/1e6,1) volume_mln
      FROM lc_loans GROUP BY issue_year)
ORDER BY issue_year;

-- 31. Rüblük default rate necədir?
SELECT TO_CHAR(issue_d,'YYYY-"Q"Q') quarter, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY TO_CHAR(issue_d,'YYYY-"Q"Q') ORDER BY quarter;

-- 32. Kredit vermə standartları zamanla sərtləşib, yoxsa yumşalıb?
SELECT issue_year,
       ROUND(AVG(fico_avg)) avg_fico,
       ROUND(AVG(dti),1) avg_dti,
       ROUND(AVG(int_rate),2) avg_rate,
       ROUND(AVG(annual_inc)) avg_income,
       ROUND(AVG(loan_amnt)) avg_loan
FROM lc_loans GROUP BY issue_year ORDER BY issue_year;

-- 33. İl üzrə grade tərkibi necə dəyişib (portfelin keyfiyyəti)?
SELECT issue_year, grade, COUNT(*) loans,
       ROUND(RATIO_TO_REPORT(COUNT(*)) OVER (PARTITION BY issue_year)*100,1) share_in_year_pct
FROM lc_loans GROUP BY issue_year, grade ORDER BY issue_year, grade;

-- 34. Ay üzrə mövsümilik varmı (həcm və risk)?
SELECT TO_CHAR(issue_d,'MM') month_no, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY TO_CHAR(issue_d,'MM') ORDER BY month_no;


-- 35. Yaxşı və pis borclu bir-birindən nə ilə fərqlənir?
SELECT CASE is_default WHEN 0 THEN 'Ödənilib' ELSE 'Default' END status,
       COUNT(*) loans,
       ROUND(AVG(int_rate),2) avg_rate,
       ROUND(AVG(fico_avg)) avg_fico,
       ROUND(AVG(dti),1) avg_dti,
       ROUND(AVG(annual_inc)) avg_income,
       ROUND(AVG(loan_amnt)) avg_loan,
       ROUND(AVG(revol_util),1) avg_revol_util,
       ROUND(AVG(credit_history_years),1) avg_history_yrs
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY is_default ORDER BY is_default;

-- 36. Kredit tarixçəsinin uzunluğu riskə necə təsir edir?
SELECT history_band, COUNT(*) loans, ROUND(AVG(is_default)*100,2) default_rate_pct
FROM (SELECT is_default,
             CASE WHEN credit_history_years < 5 THEN '1) <5 il'
                  WHEN credit_history_years < 10 THEN '2) 5-10 il'
                  WHEN credit_history_years < 15 THEN '3) 10-15 il'
                  WHEN credit_history_years < 20 THEN '4) 15-20 il'
                  ELSE '5) 20+ il' END history_band
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY history_band ORDER BY history_band;

-- 37. Dövri kredit istifadəsi (revolving utilization) riski necə artırır?
SELECT util_band, COUNT(*) loans, ROUND(AVG(is_default)*100,2) default_rate_pct
FROM (SELECT is_default,
             CASE WHEN revol_util <= 25 THEN '1) 0-25%'
                  WHEN revol_util <= 50 THEN '2) 25-50%'
                  WHEN revol_util <= 75 THEN '3) 50-75%'
                  WHEN revol_util <= 100 THEN '4) 75-100%'
                  ELSE '5) 100%+' END util_band
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY util_band ORDER BY util_band;

-- 38. Son 6 ayda çox kredit sorğusu verənlər daha riskli?
SELECT LEAST(FLOOR(inq_last_6mths),4) inquiries_6m_capped, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY LEAST(FLOOR(inq_last_6mths),4) ORDER BY 1;

-- 39. Son 2 ildə gecikmə yaşayanlar daha çox default olur?
SELECT LEAST(FLOOR(delinq_2yrs),4) delinq_2yrs_capped, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY LEAST(FLOOR(delinq_2yrs),4) ORDER BY 1;

-- 40. İctimai qeydlər (public record) və iflas riski artırır?
SELECT LEAST(FLOOR(pub_rec),2) pub_rec_capped,
       LEAST(FLOOR(pub_rec_bankruptcies),1) bankruptcy_flag,
       COUNT(*) loans, ROUND(AVG(is_default)*100,2) default_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY LEAST(FLOOR(pub_rec),2), LEAST(FLOOR(pub_rec_bankruptcies),1)
ORDER BY 1, 2;

-- 41. İpoteka hesabı olanlar daha etibarlıdırmı?
SELECT LEAST(FLOOR(mort_acc),5) mort_acc_capped, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY LEAST(FLOOR(mort_acc),5) ORDER BY 1;

-- 42. Açıq kredit hesablarının sayı riskə necə təsir edir?
SELECT open_band, COUNT(*) loans, ROUND(AVG(is_default)*100,2) default_rate_pct
FROM (SELECT is_default,
             CASE WHEN open_acc <= 5 THEN '1) 0-5'
                  WHEN open_acc <= 10 THEN '2) 6-10'
                  WHEN open_acc <= 15 THEN '3) 11-15'
                  WHEN open_acc <= 20 THEN '4) 16-20'
                  ELSE '5) 20+' END open_band
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY open_band ORDER BY open_band;

-- 43. Kredit/gəlir nisbəti yüksək olanlar daha riskli?
SELECT lti_band, COUNT(*) loans, ROUND(AVG(is_default)*100,2) default_rate_pct
FROM (SELECT is_default,
             CASE WHEN loan_to_income < 0.1 THEN '1) <10%'
                  WHEN loan_to_income < 0.2 THEN '2) 10-20%'
                  WHEN loan_to_income < 0.3 THEN '3) 20-30%'
                  WHEN loan_to_income < 0.5 THEN '4) 30-50%'
                  ELSE '5) 50%+' END lti_band
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY lti_band ORDER BY lti_band;

-- 44. İllik ödəniş yükü (taksitlər/gəlir) risk üçün nə deməkdir?
SELECT burden_band, COUNT(*) loans, ROUND(AVG(is_default)*100,2) default_rate_pct
FROM (SELECT is_default,
             CASE WHEN installment_to_income < 0.05 THEN '1) <5%'
                  WHEN installment_to_income < 0.10 THEN '2) 5-10%'
                  WHEN installment_to_income < 0.15 THEN '3) 10-15%'
                  WHEN installment_to_income < 0.20 THEN '4) 15-20%'
                  ELSE '5) 20%+' END burden_band
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY burden_band ORDER BY burden_band;


-- 45. Bütün portfelin Expected Loss göstəriciləri nədir?
SELECT COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) pd_pct,
       ROUND(AVG(CASE WHEN is_default=1 THEN unpaid_principal END)) ead_avg,
       ROUND((1 - SUM(CASE WHEN is_default=1 THEN recoveries END)
                  / SUM(CASE WHEN is_default=1 THEN unpaid_principal END))*100,2) lgd_pct,
       ROUND(SUM(net_loss)) el_usd,
       ROUND(SUM(net_loss)/SUM(loan_amnt)*100,2) el_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015;

-- 46. Hansı grade nə qədər itki yaradır?
SELECT grade, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) pd_pct,
       ROUND(AVG(CASE WHEN is_default=1 THEN unpaid_principal END)) ead_avg,
       ROUND((1 - SUM(CASE WHEN is_default=1 THEN recoveries END)
                  / SUM(CASE WHEN is_default=1 THEN unpaid_principal END))*100,2) lgd_pct,
       ROUND(SUM(net_loss)) el_usd,
       ROUND(SUM(net_loss)/SUM(loan_amnt)*100,2) el_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY grade ORDER BY grade;

-- 47. Müddət üzrə Expected Loss
SELECT term, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) pd_pct,
       ROUND(AVG(CASE WHEN is_default=1 THEN unpaid_principal END)) ead_avg,
       ROUND((1 - SUM(CASE WHEN is_default=1 THEN recoveries END)
                  / SUM(CASE WHEN is_default=1 THEN unpaid_principal END))*100,2) lgd_pct,
       ROUND(SUM(net_loss)) el_usd,
       ROUND(SUM(net_loss)/SUM(loan_amnt)*100,2) el_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY term ORDER BY term;

-- 48. Kredit məqsədi üzrə Expected Loss
SELECT purpose, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) pd_pct,
       ROUND(AVG(CASE WHEN is_default=1 THEN unpaid_principal END)) ead_avg,
       ROUND((1 - SUM(CASE WHEN is_default=1 THEN recoveries END)
                  / SUM(CASE WHEN is_default=1 THEN unpaid_principal END))*100,2) lgd_pct,
       ROUND(SUM(net_loss)) el_usd,
       ROUND(SUM(net_loss)/SUM(loan_amnt)*100,2) el_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY purpose HAVING COUNT(*) >= 3000
ORDER BY el_rate_pct DESC;

-- 49. Ştatlar üzrə Expected Loss (ən riskli 15)
SELECT addr_state, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) pd_pct,
       ROUND(AVG(CASE WHEN is_default=1 THEN unpaid_principal END)) ead_avg,
       ROUND((1 - SUM(CASE WHEN is_default=1 THEN recoveries END)
                  / SUM(CASE WHEN is_default=1 THEN unpaid_principal END))*100,2) lgd_pct,
       ROUND(SUM(net_loss)) el_usd,
       ROUND(SUM(net_loss)/SUM(loan_amnt)*100,2) el_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY addr_state HAVING COUNT(*) >= 5000
ORDER BY el_rate_pct DESC FETCH FIRST 15 ROWS ONLY;

-- 50. Grade × müddət üzrə Expected Loss
SELECT grade, term, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) pd_pct,
       ROUND(AVG(CASE WHEN is_default=1 THEN unpaid_principal END)) ead_avg,
       ROUND((1 - SUM(CASE WHEN is_default=1 THEN recoveries END)
                  / SUM(CASE WHEN is_default=1 THEN unpaid_principal END))*100,2) lgd_pct,
       ROUND(SUM(net_loss)) el_usd,
       ROUND(SUM(net_loss)/SUM(loan_amnt)*100,2) el_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY grade, term ORDER BY grade, term;

-- 51. İl üzrə Expected Loss (vintage itki əyrisi)
SELECT issue_year, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) pd_pct,
       ROUND(AVG(CASE WHEN is_default=1 THEN unpaid_principal END)) ead_avg,
       ROUND((1 - SUM(CASE WHEN is_default=1 THEN recoveries END)
                  / SUM(CASE WHEN is_default=1 THEN unpaid_principal END))*100,2) lgd_pct,
       ROUND(SUM(net_loss)) el_usd,
       ROUND(SUM(net_loss)/SUM(loan_amnt)*100,2) el_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY issue_year ORDER BY issue_year;

-- 52. FICO seqmenti üzrə Expected Loss
SELECT fico_band, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) pd_pct,
       ROUND(AVG(CASE WHEN is_default=1 THEN unpaid_principal END)) ead_avg,
       ROUND((1 - SUM(CASE WHEN is_default=1 THEN recoveries END)
                  / SUM(CASE WHEN is_default=1 THEN unpaid_principal END))*100,2) lgd_pct,
       ROUND(SUM(net_loss)) el_usd,
       ROUND(SUM(net_loss)/SUM(loan_amnt)*100,2) el_rate_pct
FROM (SELECT is_default, unpaid_principal, recoveries, net_loss, loan_amnt,
             CASE WHEN fico_avg < 660 THEN '1) <660'
                  WHEN fico_avg < 700 THEN '2) 660-700'
                  WHEN fico_avg < 740 THEN '3) 700-740'
                  WHEN fico_avg < 780 THEN '4) 740-780'
                  ELSE '5) 780+' END fico_band
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY fico_band ORDER BY fico_band;

-- 53. DTI seqmenti üzrə Expected Loss
SELECT dti_band, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) pd_pct,
       ROUND(AVG(CASE WHEN is_default=1 THEN unpaid_principal END)) ead_avg,
       ROUND((1 - SUM(CASE WHEN is_default=1 THEN recoveries END)
                  / SUM(CASE WHEN is_default=1 THEN unpaid_principal END))*100,2) lgd_pct,
       ROUND(SUM(net_loss)) el_usd,
       ROUND(SUM(net_loss)/SUM(loan_amnt)*100,2) el_rate_pct
FROM (SELECT is_default, unpaid_principal, recoveries, net_loss, loan_amnt,
             CASE WHEN dti <= 10 THEN '1) 0-10'
                  WHEN dti <= 20 THEN '2) 10-20'
                  WHEN dti <= 30 THEN '3) 20-30'
                  WHEN dti <= 40 THEN '4) 30-40'
                  ELSE '5) 40+' END dti_band
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY dti_band ORDER BY dti_band;

-- 54. Ən çox itki yaradan 10 seqment (grade × məqsəd) hansılardır?
SELECT grade, purpose, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) pd_pct,
       ROUND(SUM(net_loss)) el_usd,
       ROUND(SUM(net_loss)/SUM(loan_amnt)*100,2) el_rate_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY grade, purpose
ORDER BY el_usd DESC FETCH FIRST 10 ROWS ONLY;

-- 55. Default olan kreditlərdən nə qədər geri qaytarılır (recovery rate)?
SELECT grade, COUNT(*) defaults,
       ROUND(SUM(unpaid_principal)) unpaid_usd,
       ROUND(SUM(recoveries)) recovered_usd,
       ROUND(SUM(recoveries)/SUM(unpaid_principal)*100,2) recovery_rate_pct
FROM lc_loans WHERE is_default = 1 AND issue_year BETWEEN 2009 AND 2015
GROUP BY grade ORDER BY grade;

-- 56. Pareto: itkinin 80%-ni hansı sub-grade-lərdən gəlir?
SELECT sub_grade, el_usd,
       ROUND(el_usd / SUM(el_usd) OVER ()*100,1) share_pct,
       ROUND(SUM(el_usd) OVER (ORDER BY el_usd DESC) / SUM(el_usd) OVER ()*100,1) cum_share_pct
FROM (SELECT sub_grade, ROUND(SUM(net_loss)) el_usd
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
      GROUP BY sub_grade)
ORDER BY el_usd DESC;


-- 57. Hansı grade pul qazandırır, hansı itirir?
SELECT grade, COUNT(*) loans,
       ROUND(SUM(loan_amnt)/1e6,1) volume_mln,
       ROUND(SUM(profit)/1e6,2) profit_mln,
       ROUND(SUM(profit)/SUM(loan_amnt)*100,2) roi_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY grade ORDER BY grade;

-- 58. 36 və 60 aylıq kreditlərin gəlirliliyi nə qədərdir?
SELECT term, COUNT(*) loans,
       ROUND(SUM(profit)/1e6,2) profit_mln,
       ROUND(SUM(profit)/SUM(loan_amnt)*100,2) roi_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY term ORDER BY term;

-- 59. Hansı il üzrə kreditlər daha gəlirli olub?
SELECT issue_year, COUNT(*) loans,
       ROUND(SUM(profit)/1e6,2) profit_mln,
       ROUND(SUM(profit)/SUM(loan_amnt)*100,2) roi_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY issue_year ORDER BY issue_year;

-- 60. Ən az gəlirli (və ya zərərli) 10 seqment (grade × müddət × məqsəd)
SELECT grade, term, purpose, COUNT(*) loans,
       ROUND(SUM(profit)) profit_usd,
       ROUND(SUM(profit)/SUM(loan_amnt)*100,2) roi_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY grade, term, purpose HAVING COUNT(*) >= 3000
ORDER BY roi_pct ASC FETCH FIRST 10 ROWS ONLY;

-- 61. Faiz itkini örtürmü? (təxmini illik itki ilə müqayisə)
SELECT grade,
       ROUND(AVG(int_rate),2) avg_rate_pct,
       ROUND(SUM(net_loss)/SUM(loan_amnt)*100,2) total_loss_rate_pct,
       ROUND(SUM(net_loss)/SUM(loan_amnt)*100 / (AVG(term)/12),2) approx_annual_loss_pct,
       ROUND(AVG(int_rate) - SUM(net_loss)/SUM(loan_amnt)*100 / (AVG(term)/12),2) approx_spread_pct
FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
GROUP BY grade ORDER BY grade;

-- 62. Gəlir seqmentinə görə gəlirlilik necədir?
SELECT income_band, COUNT(*) loans,
       ROUND(SUM(profit)/1e6,2) profit_mln,
       ROUND(SUM(profit)/SUM(loan_amnt)*100,2) roi_pct
FROM (SELECT profit, loan_amnt,
             CASE WHEN annual_inc < 30000 THEN '1) <30k'
                  WHEN annual_inc < 50000 THEN '2) 30-50k'
                  WHEN annual_inc < 75000 THEN '3) 50-75k'
                  WHEN annual_inc < 100000 THEN '4) 75-100k'
                  ELSE '5) 100k+' END income_band
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY income_band ORDER BY income_band;


-- 63. FICO cut-off: müəyyən skordan aşağını rədd etsək nə qədər default qaçırırıq, neçə müştəri itirik?
SELECT fico_bucket, loans, defaults,
       ROUND(defaults/loans*100,2) bucket_dr_pct,
       ROUND(SUM(loans) OVER (ORDER BY fico_bucket) / SUM(loans) OVER ()*100,1) cum_rejected_loans_pct,
       ROUND(SUM(defaults) OVER (ORDER BY fico_bucket) / SUM(defaults) OVER ()*100,1) cum_defaults_avoided_pct
FROM (SELECT FLOOR(fico_avg/10)*10 fico_bucket, COUNT(*) loans, SUM(is_default) defaults
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
      GROUP BY FLOOR(fico_avg/10)*10)
ORDER BY fico_bucket;

-- 64. Yüksək və aşağı risk profilləri arasında fərq nə qədərdir?
SELECT risk_profile, COUNT(*) loans,
       ROUND(AVG(is_default)*100,2) default_rate_pct,
       ROUND(SUM(net_loss)/SUM(loan_amnt)*100,2) el_rate_pct
FROM (SELECT is_default, net_loss, loan_amnt,
             CASE WHEN fico_avg < 680 AND dti > 25 AND term = 60 THEN '1) Yüksək risk (FICO<680, DTI>25, 60 ay)'
                  WHEN fico_avg >= 740 AND dti <= 15 AND term = 36 THEN '3) Aşağı risk (FICO>=740, DTI<=15, 36 ay)'
                  ELSE '2) Digər' END risk_profile
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY risk_profile ORDER BY risk_profile;

-- 65. Ən təhlükəsiz niş (A/B grade, 36 ay, FICO>=740) portfelin nə qədərini təşkil edir və nə qazandırır?
SELECT COUNT(*) loans,
       ROUND(COUNT(*)/(SELECT COUNT(*) FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)*100,1) portfolio_share_pct,
       ROUND(AVG(is_default)*100,2) default_rate_pct,
       ROUND(AVG(int_rate),2) avg_rate,
       ROUND(SUM(profit)/SUM(loan_amnt)*100,2) roi_pct
FROM lc_loans
WHERE grade IN ('A','B') AND term = 36 AND fico_avg >= 740
  AND issue_year BETWEEN 2009 AND 2015;

-- 66. Faiz dərəcəsi decile-ləri üzrə default rate monoton artırmı?
SELECT decile_no, COUNT(*) loans,
       ROUND(MIN(int_rate),2) min_rate, ROUND(MAX(int_rate),2) max_rate,
       ROUND(AVG(is_default)*100,2) default_rate_pct
FROM (SELECT int_rate, is_default, NTILE(10) OVER (ORDER BY int_rate) decile_no
      FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
GROUP BY decile_no ORDER BY decile_no;

-- 67. FICO decile-ləri defaultları nə qədər yaxşı tutur? (decile 1 = ən aşağı skor)
SELECT decile_no, loans, defaults,
       ROUND(defaults/SUM(defaults) OVER ()*100,1) share_of_defaults_pct,
       ROUND(SUM(defaults) OVER (ORDER BY decile_no) / SUM(defaults) OVER ()*100,1) cum_capture_pct
FROM (SELECT decile_no, COUNT(*) loans, SUM(is_default) defaults
      FROM (SELECT is_default, NTILE(10) OVER (ORDER BY fico_avg) decile_no
            FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015)
      GROUP BY decile_no)
ORDER BY decile_no;

-- 68. Coğrafi konsentrasiya: ilk 10 ştat portfelin neçə faizidir?
SELECT addr_state, ROUND(volume/1e6,1) volume_mln,
       ROUND(volume / SUM(volume) OVER ()*100,2) share_pct,
       ROUND(SUM(volume) OVER (ORDER BY volume DESC) / SUM(volume) OVER ()*100,1) cum_share_pct
FROM (SELECT addr_state, SUM(loan_amnt) volume FROM lc_loans GROUP BY addr_state)
ORDER BY volume DESC FETCH FIRST 10 ROWS ONLY;

-- 69. Data keyfiyyəti: məntiqsiz və ya şübhəli qeydlər varmı?
SELECT COUNT(*) total_rows,
       SUM(CASE WHEN annual_inc <= 0 THEN 1 ELSE 0 END) zero_income,
       SUM(CASE WHEN dti < 0 OR dti > 100 THEN 1 ELSE 0 END) odd_dti,
       SUM(CASE WHEN fico_avg < 300 OR fico_avg > 850 THEN 1 ELSE 0 END) odd_fico,
       SUM(CASE WHEN total_rec_prncp > loan_amnt + 1 THEN 1 ELSE 0 END) overpaid_principal,
       SUM(CASE WHEN earliest_cr_line > issue_d THEN 1 ELSE 0 END) history_after_issue,
       SUM(CASE WHEN issue_d IS NULL THEN 1 ELSE 0 END) null_issue_date
FROM lc_loans;

-- 70. Ən riskli 15 seqment (grade × müddət × məqsəd) EL rate-ə görə sıralanmış
SELECT * FROM (
    SELECT grade, term, purpose, COUNT(*) loans,
           ROUND(AVG(is_default)*100,2) pd_pct,
           ROUND(SUM(net_loss)/SUM(loan_amnt)*100,2) el_rate_pct,
           ROUND(SUM(net_loss)) el_usd,
           RANK() OVER (ORDER BY SUM(net_loss)/SUM(loan_amnt) DESC) risk_rank
    FROM lc_loans WHERE issue_year BETWEEN 2009 AND 2015
    GROUP BY grade, term, purpose HAVING COUNT(*) >= 3000
) WHERE risk_rank <= 15 ORDER BY risk_rank;


