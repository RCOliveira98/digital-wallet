namespace :dev do
  desc "Configura db para ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?

      show_spinner('Apagando banco de dados ...') { %x(rails db:drop) }
      show_spinner('Criando banco de dados ...') { %x(rails db:create) }
      show_spinner('Executando migrações ...') { %x(rails db:migrate) }
      show_spinner('Populando tabela tipos de mineração ...') { %x(rails dev:add_mining_types) }
      show_spinner('Populando tabela moedas ...') { %x(rails dev:add_coins) }

    end
  end

  desc "Popula a tabela de moedas da base de dados"
  task add_coins: :environment do
    coins = get_coins()

    coins.each{ |coin| Coin.find_or_create_by!(coin) }
  end

  desc "Popula a tabela de 'tipos de mineração de moedas' da base de dados"
  task add_mining_types: :environment do
    mining_types = get_mining_types()

    mining_types.each{ |mining_type| MiningType.find_or_create_by!(mining_type) }
  end

  private
  def get_coins
    mining_types = MiningType.all()
    [
      {
        description: 'Bitcoin',
        acronym: 'BTC',
        url_image: 'https://toppng.com/uploads/preview/bitcoin-png-bitcoin-logo-transparent-background-11562933997uxok6gcqjp.png',
        mining_type_id: mining_types.sample().id
      },
      {
        description: 'Ethereum',
        acronym: 'ETC',
        url_image: 'https://img2.gratispng.com/20180703/ozg/kisspng-ethereum-bitcoin-cryptocurrency-logo-litecoin-mine-5b3b57d6d70373.0863840815306157668807.jpg',
        mining_type_id: mining_types.sample().id
      },
      {
        description: 'XRP',
        acronym: 'XRP',
        url_image: 'https://www.pngfind.com/pngs/m/17-170065_xrp-symbol-xrp-new-logo-png-transparent-png.png',
        mining_type_id: mining_types.sample().id
      },
      {
        description: 'Binance coin',
        acronym: 'BNC',
        url_image: 'https://assets.coingecko.com/coins/images/825/large/binance-coin-logo.png?1547034615',
        mining_type_id: mining_types.sample().id
      }
    ]
  end

  def get_mining_types
    [
      {description: 'Poow odf poow', acronym: 'PoP'},
      {description: 'Poow odf Soow', acronym: 'PoS'},
      {description: 'Poow odf Toow', acronym: 'PoT'}
    ]
  end

  def show_spinner(task_name, msg_success = 'Concluído!')
    spinner = TTY::Spinner.new("[:spinner] #{task_name}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_success})")
  end

end
