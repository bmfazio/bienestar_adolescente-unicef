ece_load <- drake_plan(
  ece =
    fread(
      file_in("MINEDUDIR__/ece/ECE_2016_2S_alumnos.csv")) %>%
    mutate(
      sexo = toupper(sexo),
      Distrito =
        ifelse(Distrito == "ANCO_HUALLO",
               "ANCO HUALLO", Distrito),
      Region26 =
        case_when(
          Region26 == "LIMA" & Provincia == "LIMA" ~ "LIMA METROPOLITANA",
          Region26 == "LIMA" & Provincia != "LIMA" ~ "LIMA REGION",
          TRUE ~ Region26)) %>%
    as.data.table,
  ece_ready =
rbind(
  ece[!(is.na(aj_c)|is.na(aj_m)),
      .(read = 100*sum(ifelse(grupo_L == "Satisfactorio", aj_c, 0))/sum(aj_c),
        math = 100*sum(ifelse(grupo_M == "Satisfactorio", aj_m, 0))/sum(aj_m)),
      .(desag = rep("NACIONAL", nrow(ece[!(is.na(aj_c)|is.na(aj_m))])))],
  ece[!(is.na(aj_c)|is.na(aj_m)),
      .(read = 100*sum(ifelse(grupo_L == "Satisfactorio", aj_c, 0))/sum(aj_c),
        math = 100*sum(ifelse(grupo_M == "Satisfactorio", aj_m, 0))/sum(aj_m)),
      .(desag = sexo)],
  ece[!(is.na(aj_c)|is.na(aj_m)),
      .(read = 100*sum(ifelse(grupo_L == "Satisfactorio", aj_c, 0))/sum(aj_c),
        math = 100*sum(ifelse(grupo_M == "Satisfactorio", aj_m, 0))/sum(aj_m)),
      .(desag = Area %>% toupper)],
  ece[!(is.na(aj_c)|is.na(aj_m)),
      .(read = 100*sum(ifelse(grupo_L == "Satisfactorio", aj_c, 0))/sum(aj_c),
        math = 100*sum(ifelse(grupo_M == "Satisfactorio", aj_m, 0))/sum(aj_m)),
      .(desag =
          Region26 %>% iconv(from = "latin1", to = "ASCII//TRANSLIT") %>%
          toupper)],
  ece[!(is.na(aj_c)|is.na(aj_m)),
      .(read = 100*sum(ifelse(grupo_L == "Satisfactorio", aj_c, 0))/sum(aj_c),
        math = 100*sum(ifelse(grupo_M == "Satisfactorio", aj_m, 0))/sum(aj_m)),
      .(desag = 
          paste(Region26 %>% iconv(from = "latin1", to = "ASCII//TRANSLIT") %>%
        toupper, sexo, sep = "_"))],
  ece[!(is.na(aj_c)|is.na(aj_m)),
      .(read = 100*sum(ifelse(grupo_L == "Satisfactorio", aj_c, 0))/sum(aj_c),
        math = 100*sum(ifelse(grupo_M == "Satisfactorio", aj_m, 0))/sum(aj_m)),
      .(desag = 
          paste(Region26 %>% iconv(from = "latin1", to = "ASCII//TRANSLIT") %>%
        toupper, Area %>% toupper, sep = "_"))],
  ece[!(is.na(aj_c)|is.na(aj_m)),
      .(read = 100*sum(ifelse(grupo_L == "Satisfactorio", aj_c, 0))/sum(aj_c),
        math = 100*sum(ifelse(grupo_M == "Satisfactorio", aj_m, 0))/sum(aj_m)),
      .(desag =
          paste(Region26 %>% iconv(from = "latin1", to = "ASCII//TRANSLIT") %>% toupper,
          Provincia %>% iconv(from = "latin1", to = "ASCII//TRANSLIT") %>% toupper,
          Distrito %>% iconv(from = "latin1", to = "ASCII//TRANSLIT") %>% toupper,
          sep = "_"))],
  ece[!(is.na(aj_c)|is.na(aj_m)),
      .(read = 100*sum(ifelse(grupo_L == "Satisfactorio", aj_c, 0))/sum(aj_c),
        math = 100*sum(ifelse(grupo_M == "Satisfactorio", aj_m, 0))/sum(aj_m)),
      .(desag =
        paste(Region26 %>% iconv(from = "latin1", to = "ASCII//TRANSLIT") %>% toupper,
          Provincia %>% iconv(from = "latin1", to = "ASCII//TRANSLIT") %>% toupper,
          Distrito %>% iconv(from = "latin1", to = "ASCII//TRANSLIT") %>% toupper,
          sexo, sep = "_"))],
  ece[!(is.na(aj_c)|is.na(aj_m)),
      .(read = 100*sum(ifelse(grupo_L == "Satisfactorio", aj_c, 0))/sum(aj_c),
        math = 100*sum(ifelse(grupo_M == "Satisfactorio", aj_m, 0))/sum(aj_m)),
      .(desag =
          paste(Region26 %>% iconv(from = "latin1", to = "ASCII//TRANSLIT") %>% toupper,
          Provincia %>% iconv(from = "latin1", to = "ASCII//TRANSLIT") %>% toupper,
          Distrito %>% iconv(from = "latin1", to = "ASCII//TRANSLIT") %>% toupper,
          Area %>% toupper, sep = "_"))],
  ece[!(is.na(aj_c)|is.na(aj_m)),
      .(read = 100*sum(ifelse(grupo_L == "Satisfactorio", aj_c, 0))/sum(aj_c),
        math = 100*sum(ifelse(grupo_M == "Satisfactorio", aj_m, 0))/sum(aj_m)),
      .(desag =
        paste(Region26 %>% iconv(from = "latin1", to = "ASCII//TRANSLIT") %>% toupper,
          Provincia %>% iconv(from = "latin1", to = "ASCII//TRANSLIT") %>% toupper,
          Distrito %>% iconv(from = "latin1", to = "ASCII//TRANSLIT") %>% toupper,
          sexo, Area %>% toupper,
          sep = "_"))])
) %>%
  evaluate_plan(
    rules = list(MINEDUDIR__ = minedudir),
    expand = FALSE
  )