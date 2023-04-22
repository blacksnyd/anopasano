module ApplicationHelper
  def default_meta_tags
    {
      site: 'Découvre qui se cache derrière l\'ano',
      title: 'Wolfiak',
      reverse: true,
      separator: '-',
      description: "Découvre le réel pseudo d’un joueur Wolfy en anonyme grâce à son UUID !",
      keywords: 'anonyme, joueur, wolfy, partie, game, player, uuid',
      canonical: "https://thewolfiak.herokuapp.com/",
      noindex: !Rails.env.production?,
      icon: [
        { href: image_url('wolfiak-32x32.png'), rel: 'icon', sizes: '32x32', type: 'image/png' }
      ],
      og: {
        site_name: 'thewolfiak.herokuapp.com',
        title: 'Wolfiak',
        description: "Découvre le réel pseudo d’un joueur Wolfy en anonyme grâce à son UUID !",
        type: 'website',
        url: "https://thewolfiak.herokuapp.com/",
        image: image_url('wolfiak-banner.svg')
      }
    }
  end
end
