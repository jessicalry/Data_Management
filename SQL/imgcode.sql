continents
	int continent_id
	varchar name

countries
	int country_id
	varchar name
	decimal area
	date national_day
	char country_code2
	char country_code3
	int region_id

region_areas
	varchar region_name
	decimal region_area

regions
	int region_id
	varchar name
	int continent_id

languages
	int language_id
	varchar language

country_languages
	int country_id
	int language_id
	smallint official

country_stats
	int country_id
	int year
	int polulation
	decimal gdp

regions {1..n}-are in-{1} continents
regions {1}-have-{1} region_areas
countries {1..n}-are in-{1} regions
countries {1}-contain-{0..n} country_languages
languages {1}-contain-{1..n} country_languages
country_stats {0..n}-have-{1} countries

