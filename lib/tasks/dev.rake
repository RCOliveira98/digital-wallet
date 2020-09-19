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
        url_image: 'https://lh3.googleusercontent.com/proxy/b2mgnN_hNS7gY9qdJaDkrf5JSrNsdC4ETEaaNBNS2AMs_nTeuVGKB98wVwCP6L5VKs9Pne61-lCnLMhadjXc2aCfaOqk1OcyoT8-EuF5YHXqM9W2hwM',
        mining_type: mining_types.sample()
      },
      {
        description: 'Ethereum',
        acronym: 'ETC',
        url_image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/ETHEREUM-YOUTUBE-PROFILE-PIC.png/600px-ETHEREUM-YOUTUBE-PROFILE-PIC.png',
        mining_type: mining_types.sample()
      },
      {
        description: 'RIPPLE XRP',
        acronym: 'XRP',
        url_image: 'https://www.iconfinder.com/data/icons/crypto-currency-and-coin-2/256/ripple_xrp_coin-512.png',
        mining_type: mining_types.sample()
      },
      {
        description: 'Binance coin',
        acronym: 'BNC',
        url_image: 'https://assets.coingecko.com/coins/images/825/large/binance-coin-logo.png?1547034615',
        mining_type: mining_types.sample()
      },
      {
        description: ' Tether',
        acronym: 'TTH',
        url_image: 'https://seeklogo.com/images/T/tether-usdt-logo-FA55C7F397-seeklogo.com.png ',
        mining_type: mining_types.sample()
      },
      {
        description: 'Litecoin',
        acronym: 'LTC',
        url_image: 'https://www.iconfinder.com/data/icons/cryptocurrency-round-black-transparency/128/Blockchain_cryptocurrency_currency_litecoin_ltc_3-512.png',
        mining_type: mining_types.sample()
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
