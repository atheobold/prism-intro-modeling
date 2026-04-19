dat <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-01-09/nhl_rosters.csv")
dat2 <- read_csv("./data/Player_Data.csv")

dat2 <- dat2 |>
  mutate(
    first_name = str_extract(Player, "[A-Z][A-z]+"),
    last_name = str_extract(Player, "[A-Z][A-z]+(?=\\\\)"),
    season = as.character(Season),
    goals = G,
    assists = A,
    points = PTS,
    games_played = GP,
    penalty_minutes = PIM
  )

data_nhl <- dat |>
  mutate(
    season = str_extract(season, "[0-9]{4}")
  ) |>
  inner_join(dat2,
    by = join_by(season, first_name, last_name),
    relationship = "many-to-many"
  ) |>
  select(
    season,
    team_code,
    first_name,
    last_name,
    position_code,
    position_type,
    sweater_number,
    height_in_inches,
    weight_in_pounds,
    birth_date,
    birth_city,
    birth_country,
    birth_state_province,
    games_played,
    goals,
    assists,
    points,
    plusminus,
    penalty_minutes
  )

### Add some messiness

fake_player <- tibble(
  first_name = "Happy",
  last_name = "Gilmore",
  team_code = "BOS",
  age = 99,
  points = 212,
  penalty_minutes = 700,
  sweater_number = 18,
  season = "1996",
  position_code = "L", 
  position_type = "forwards", 
  height_in_inches = 71, 
  weight_in_pounds = 200
)

data_nhl <- data_nhl |>
  bind_rows(fake_player) |>
  rename(
    height = height_in_inches,
    weight = weight_in_pounds,
    team = team_code
  )

data_nhl <- data_nhl |>
  mutate(
    age = parse_number(season) - year(birth_date),
    birth_month = month(birth_date)
  )

write_csv(data_nhl, "./data/nhl_player_stats.csv")
