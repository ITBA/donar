  # encoding: utf-8

  # We create a small of "almost real" objects to have for Demo Purposes

  # User creation

  martin = User.new(
    email: 'mmarquez@gmail.com',
    password: '12345678',
    password_confirmation: '12345678'
  )
  martin.skip_confirmation!
  marti.save!

  esteban = User.new(
    email: 'epintos7@gmail.com',
    password: '12345678',
    password_confirmation: '12345678'
  )
  esteban.skip_confirmation!
  esteban.save!

  diego = User.new(
    email: 'strubolini@gmail.com',
    password: '12345678',
    password_confirmation: '12345678'
  )
  diego.skip_confirmation!
  diego.save!

  matias = User.new(
    email: 'mdesanti90@gmail.com',
    password: '12345678',
    password_confirmation: '12345678'
  )
  matias.skip_confirmation!
  matias.save!

  federico = User.new(
    email: 'federicohomovc@gmail.com',
    password: '12345678',
    password_confirmation: '12345678'
  )
  federico.skip_confirmation!
  federico.save!

  # Organization creation

  cemic = Organization.create(
    name: 'CEMIC',
    description: 'Centro de Educación Médica e Investigaciones Clínicas',
    locality: 'Argentina',
    users: [martin, esteban]
  )

  coas = Organization.create(
    name: 'COAS',
    description: 'Cooperadora de Acción Social',
    locality: 'Argentina',
    users: [martin, diego]
  )

  agrupar = Organization.create(
    name: 'Fundación Agrupar',
    description: 'Fundación cuya misión es promover, facilitar, apoyar y desarrollar ' +
    'actividades tendientes a mejorar la calidad de vida de la comunidad en armonía ' +
    'con la naturaleza.',
    locality: 'Argentina',
    users: [esteban, matias, federico]
  )

  cruz_roja = Organization.create(
    name: 'Cruz Roja Argentina',
    description: 'Asociación Civil, humanitaria y de carácter voluntario, con presencia ' +
    'en todo el territorio argentino. Una de las 187 Sociedades Nacionales que integran ' +
    'el Movimiento Internacional de la Cruz Roja y Media Luna Roja.',
    locality: 'Argentina',
    users: [diego, esteban, matias]
  )

  # Campaign creation

  tomografo_sticker = Perk.create(
    amount: 100.0,
    name: 'Sticker "Yo ayude a comprar le nuevo tomógrafo del CEMIC"',
    maximun: 100,
    description: 'Un sticker'
  )

  tomografo_visit = Perk.create(
    amount: 1000.0,
    name: 'Visita guiada por el CEMIC',
    maximun: 10,
    description: 'Una visita'
  )


  tomografo_cemic = Campaign.create(
    name: 'Nuevo tomógrafo',
    description: 'El objetivo es comprar el tomografo computado General Electric '+
    'CT Max 640',
    goal: 100000.0,
    deadline: DateTime.current + 1.month,
    minimum: 1.0,
    category: 'buys',
    locality: 'Argentina',
    short_description: 'Un nuevo tomógrafo para el CEMIC',
    organization: cemic,
    perks: [tomografo_sticker, tomografo_visit],
    contributions: [
      Contribution.create(user: martin, perk: tomografo_sticker, amount: 100.0),
      Contribution.create(user: diego, perk: tomografo_sticker, amount: 200.0),
      Contribution.create(user: federico, perk: tomografo_visit, amount: 1000.0),
      Contribution.create(user: martin, perk: tomografo_visit, amount: 2000.0)
    ],
    comments: [
      Comment.create(user: matias, message: 'Quiero participar'),
      Comment.create(user: diego, message: 'Gracias por el esfuerzo!'),
      Comment.create(user: federico,
                     message:'Es hora de que tengamos un mejor tomógrafo'),
      Comment.create(user: martin, message: 'Que bueno! Un tomógrafo'),
      Comment.create(user: matias, message: 'Necesitamos mejor equipamiento'),
      Comment.create(user: federico,
                     message: 'Es hora de que tengamos un mejor tomógrafo'),
      Comment.create(user: federico, message: 'Felicitaciones por la iniciativa'),
      Comment.create(user: diego, message: '!!!!!!!!')
    ]
  )

  comedor_villa31 = Campaign.create(
    name: 'Comedor 31',
    description: 'COAS busca crear un comedor infantil para 500 niños que funcione en ' +
    'la Villa 31',
    goal: 200000.0,
    deadline: DateTime.current + 1.month,
    minimum: 10.0,
    category: 'food',
    locality: 'Argentina',
    short_description: 'Un nuevo comedor para la Villa 31',
    organization: coas,
    comments: [
      Comment.create(user: martin, message: 'Linda propuesta'),
      Comment.create(user: diego, message: 'Es importante que se logre'),
      Comment.create(user: federico, message: 'Fundamental para esta época de crisis'),
    ]
  )

  museo_del_arbol = Campaign.create(
    name: 'Museo del Arbol',
    description: 'El objetivo es crear un museo de los arboles que funcione al aire libre',
    goal: 100000.0,
    deadline: DateTime.current + 1.month,
    minimum: 1.0,
    category: 'startup',
    locality: 'Argentina',
    short_description: 'Un nuevo museo para mostrar la fauna de nuestra hermosa provincia',
    organization: agrupar,
    comments: [
      Comment.create(user: esteban, message: 'Siempre me gustaron los museos'),
      Comment.create(user: diego, message: 'Hay hermosos arboles en Corrientes'),
    ]
  )
