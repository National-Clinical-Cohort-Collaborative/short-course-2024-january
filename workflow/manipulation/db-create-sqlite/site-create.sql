CREATE TABLE site_latent (
  data_partner_id                 integer       primary key,
  covid_start_site                text          not null,
  relative_size                   real          not null
);
