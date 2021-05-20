
# Growth in provincial cases since the 10th case

phac_growth_cumsum <- phac_daily %>%
  select(date, prname, numconf) %>%
  mutate(
    numconf=ifelse(is.na(numconf), 0, numconf )
  ) %>%
  pivot_wider(
    names_from=prname,
    values_from=numconf
  ) %>%
  clean_names() %>%
  select(
    -repatriated_travellers,
    -canada
  )


phac_growth_since_10__bc <- phac_growth_cumsum %>%
  select(date, british_columbia) %>%
  count_days_since_1_10_100(british_columbia) %>%
  rename(
    bc_cumsum=british_columbia,
    bc_days_since_1=`...3`,
    bc_days_since_10=`...4`,
    bc_days_since_50=`...5`,
    bc_days_since_100=`...6`
  ) %>%
  select(bc_cumsum, bc_days_since_10) %>%
  mutate(province="BC") %>%
  rename(cumsum=bc_cumsum, days_since_10=bc_days_since_10)

phac_growth_since_10__ab <- phac_growth_cumsum %>%
  select(date, alberta) %>%
  count_days_since_1_10_100(alberta) %>%
  rename(
    ab_cumsum=alberta,
    ab_days_since_1=`...3`,
    ab_days_since_10=`...4`,
    ab_days_since_50=`...5`,
    ab_days_since_100=`...6`
  ) %>%
  select(ab_cumsum, ab_days_since_10) %>%
  mutate(province="AB") %>%
  rename(cumsum=ab_cumsum, days_since_10=ab_days_since_10)

phac_growth_since_10__sk <- phac_growth_cumsum %>%
  select(date, saskatchewan) %>%
  count_days_since_1_10_100(saskatchewan) %>%
  rename(
    sk_cumsum=saskatchewan,
    sk_days_since_1=`...3`,
    sk_days_since_10=`...4`,
    sk_days_since_50=`...5`,
    sk_days_since_100=`...6`
  ) %>%
  select(sk_cumsum, sk_days_since_10) %>%
  mutate(province="SK") %>%
  rename(cumsum=sk_cumsum, days_since_10=sk_days_since_10)

phac_growth_since_10__mb <- phac_growth_cumsum %>%
  select(date, manitoba) %>%
  count_days_since_1_10_100(manitoba) %>%
  rename(
    mb_cumsum=manitoba,
    mb_days_since_1=`...3`,
    mb_days_since_10=`...4`,
    mb_days_since_50=`...5`,
    mb_days_since_100=`...6`
  ) %>%
  select(mb_cumsum, mb_days_since_10) %>%
  mutate(province="MB") %>%
  rename(cumsum=mb_cumsum, days_since_10=mb_days_since_10)

phac_growth_since_10__on <- phac_growth_cumsum %>%
  select(date, ontario) %>%
  count_days_since_1_10_100(ontario) %>%
  rename(
    on_cumsum=ontario,
    on_days_since_1=`...3`,
    on_days_since_10=`...4`,
    on_days_since_50=`...5`,
    on_days_since_100=`...6`
  ) %>%
  select(on_cumsum, on_days_since_10) %>%
  mutate(province="ON") %>%
  rename(cumsum=on_cumsum, days_since_10=on_days_since_10)

phac_growth_since_10__qc <- phac_growth_cumsum %>%
  select(date, quebec) %>%
  count_days_since_1_10_100(quebec) %>%
  rename(
    qc_cumsum=quebec,
    qc_days_since_1=`...3`,
    qc_days_since_10=`...4`,
    qc_days_since_50=`...5`,
    qc_days_since_100=`...6`
  ) %>%
  select(qc_cumsum, qc_days_since_10) %>%
  mutate(province="QC") %>%
  rename(cumsum=qc_cumsum, days_since_10=qc_days_since_10)

phac_growth_since_10__nb <- phac_growth_cumsum %>%
  select(date, new_brunswick) %>%
  count_days_since_1_10_100(new_brunswick) %>%
  rename(
    nb_cumsum=new_brunswick,
    nb_days_since_1=`...3`,
    nb_days_since_10=`...4`,
    nb_days_since_50=`...5`,
    nb_days_since_100=`...6`
  ) %>%
  select(nb_cumsum, nb_days_since_10) %>%
  mutate(province="NB") %>%
  rename(cumsum=nb_cumsum, days_since_10=nb_days_since_10)

phac_growth_since_10__ns <- phac_growth_cumsum %>%
  select(date, nova_scotia) %>%
  count_days_since_1_10_100(nova_scotia) %>%
  rename(
    ns_cumsum=nova_scotia,
    ns_days_since_1=`...3`,
    ns_days_since_10=`...4`,
    ns_days_since_50=`...5`,
    ns_days_since_100=`...6`
  ) %>%
  select(ns_cumsum, ns_days_since_10) %>%
  mutate(province="NS") %>%
  rename(cumsum=ns_cumsum, days_since_10=ns_days_since_10)

phac_growth_since_10__pe <- phac_growth_cumsum %>%
  select(date, prince_edward_island) %>%
  count_days_since_1_10_100(prince_edward_island) %>%
  rename(
    pei_cumsum=prince_edward_island,
    pei_days_since_1=`...3`,
    pei_days_since_10=`...4`,
    pei_days_since_50=`...5`,
    pei_days_since_100=`...6`
  ) %>%
  select(pei_cumsum, pei_days_since_10) %>%
  mutate(province="PE") %>%
  rename(cumsum=pei_cumsum, days_since_10=pei_days_since_10)

phac_growth_since_10__nl <- phac_growth_cumsum %>%
  select(date, newfoundland_and_labrador) %>%
  count_days_since_1_10_100(newfoundland_and_labrador) %>%
  rename(
    nl_cumsum=newfoundland_and_labrador,
    nl_days_since_1=`...3`,
    nl_days_since_10=`...4`,
    nl_days_since_50=`...5`,
    nl_days_since_100=`...6`
  ) %>%
  select(nl_cumsum, nl_days_since_10) %>%
  mutate(province="NL") %>%
  rename(cumsum=nl_cumsum, days_since_10=nl_days_since_10)

phac_growth_since_10__nt <- phac_growth_cumsum %>%
  select(date, northwest_territories) %>%
  count_days_since_1_10_100(northwest_territories) %>%
  rename(
    nt_cumsum=northwest_territories,
    nt_days_since_1=`...3`,
    nt_days_since_10=`...4`,
    nt_days_since_50=`...5`,
    nt_days_since_100=`...6`
  ) %>%
  select(nt_cumsum, nt_days_since_10) %>%
  mutate(province="NT") %>%
  rename(cumsum=nt_cumsum, days_since_10=nt_days_since_10)

phac_growth_since_10__yt <- phac_growth_cumsum %>%
  select(date, yukon) %>%
  count_days_since_1_10_100(yukon) %>%
  rename(
    yt_cumsum=yukon,
    yt_days_since_1=`...3`,
    yt_days_since_10=`...4`,
    yt_days_since_50=`...5`,
    yt_days_since_100=`...6`
  ) %>%
  select(yt_cumsum, yt_days_since_10) %>%
  mutate(province="YT") %>%
  rename(cumsum=yt_cumsum, days_since_10=yt_days_since_10)

phac_growth_since_10__nu <- phac_growth_cumsum %>%
  select(date, nunavut) %>%
  count_days_since_1_10_100(nunavut) %>%
  rename(
    nu_cumsum=nunavut,
    nu_days_since_1=`...3`,
    nu_days_since_10=`...4`,
    nu_days_since_50=`...5`,
    nu_days_since_100=`...6`
  ) %>%
  select(nu_cumsum, nu_days_since_10) %>%
  mutate(province="NU") %>%
  rename(cumsum=nu_cumsum, days_since_10=nu_days_since_10)


phac_growth_since_10__tall <- rbind(
  phac_growth_since_10__bc,
  phac_growth_since_10__ab,
  phac_growth_since_10__sk,
  phac_growth_since_10__mb,
  phac_growth_since_10__on,
  phac_growth_since_10__qc,
  phac_growth_since_10__nb,
  phac_growth_since_10__ns,
  phac_growth_since_10__pe,
  phac_growth_since_10__nl,
  phac_growth_since_10__nt,
  phac_growth_since_10__yt,
  phac_growth_since_10__nu
) %>%
  filter(
    days_since_10 > 0
  )

phac_growth_since_10__tall_lastval <- rbind(
  phac_growth_since_10__bc %>% filter(province == "BC") %>% filter(days_since_10 == max(days_since_10)) %>% head(1),
  phac_growth_since_10__ab %>% filter(province == "AB") %>% filter(days_since_10 == max(days_since_10)) %>% head(1),
  phac_growth_since_10__sk %>% filter(province == "SK") %>% filter(days_since_10 == max(days_since_10)) %>% head(1),
  phac_growth_since_10__mb %>% filter(province == "MB") %>% filter(days_since_10 == max(days_since_10)) %>% head(1),
  phac_growth_since_10__on %>% filter(province == "ON") %>% filter(days_since_10 == max(days_since_10)) %>% head(1),
  phac_growth_since_10__qc %>% filter(province == "QC") %>% filter(days_since_10 == max(days_since_10)) %>% head(1),
  phac_growth_since_10__nb %>% filter(province == "NB") %>% filter(days_since_10 == max(days_since_10)) %>% head(1),
  phac_growth_since_10__ns %>% filter(province == "NS") %>% filter(days_since_10 == max(days_since_10)) %>% head(1),
  phac_growth_since_10__pe %>% filter(province == "PE") %>% filter(days_since_10 == max(days_since_10)) %>% head(1),
  phac_growth_since_10__nl %>% filter(province == "NL") %>% filter(days_since_10 == max(days_since_10)) %>% head(1),
  phac_growth_since_10__nt %>% filter(province == "NT") %>% filter(days_since_10 == max(days_since_10)) %>% head(1),
  phac_growth_since_10__yt %>% filter(province == "YT") %>% filter(days_since_10 == max(days_since_10)) %>% head(1),
  phac_growth_since_10__nu %>% filter(province == "NU") %>% filter(days_since_10 == max(days_since_10)) %>% head(1)
)

