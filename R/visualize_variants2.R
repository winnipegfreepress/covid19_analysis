

covid19_variants_mb_b117 <- covid19_variants %>% filter(variant=="B.1.1.7") %>% filter(province == "Manitoba") %>% select(count) %>% pull()
covid19_variants_mb_B1351 <- covid19_variants %>% filter(variant=="B.1.351") %>% filter(province == "Manitoba") %>% select(count) %>% pull()
covid19_variants_mb_p1 <- covid19_variants %>% filter(variant=="P.1") %>% filter(province == "Manitoba") %>% select(count) %>% pull()
covid19_variants_mb_unknown <- covid19_variants %>% filter(variant=="Uncategorized") %>% filter(province == "Manitoba") %>% select(count) %>% pull()

p_covid19_variants <- ggplot(covid19_variants) +
  aes(x=reorder(province, count), fill=variant, weight=count) +
  geom_bar() +
  scale_fill_hue() +
  coord_flip() +
  minimal_theme()

# plot(p_covid19_variants)
