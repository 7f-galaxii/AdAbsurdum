SMODS.ConsumableType {
  key = 'Antispectral',
  primary_colour = HEX("424e54"),
  secondary_colour = HEX("F945F9"),
  loc_txt = {
    name = 'Antispectral',
    collection = 'Antispectral Cards',
    undiscovered = {
      name = "what",
      text = { "how are you seeing this" },
    }
  },
  collection_rows = { 4 , 5 },
  shop_rate = 1,
}
-- Antiwraith
SMODS.Consumable {
  set = 'Antispectral',
  key = 'antiwraith',
  unlocked = true,
  discovered = false,
  loc_txt = {
    name = 'Antiwraith',
    text = { 
      'Fills Joker space with',
      '{C:red}Rare{C:attention} Jokers{},',
      'sets money to {C:red}-$20',
    }
  },
  pos = { x = 5, y = 0 },
  atlas = 'antispectral',
  cost = 8,
  can_use = function(self, card)
    if G.STATE ~= G.STATES.HAND_PLAYED and G.STATE ~= G.STATES.DRAW_TO_HAND and G.STATE ~= G.STATES.PLAY_TAROT or any_state then
      if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
        return true
      end
    end
  end,
  use = function(self, card, area, copier)
    local free_slots = G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer)
    G.GAME.joker_buffer = G.GAME.joker_buffer + free_slots
    for i = 1, free_slots do
      G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('generic1')
        local card = create_card('Joker', G.jokers, nil, 0.95, nil, nil, nil, 'antiwra')
        card:add_to_deck()
        G.jokers:emplace(card)
        card:start_materialize()
        G.GAME.joker_buffer = 0
        card:juice_up(0.3, 0.5)
        if G.GAME.dollars ~= -20 then
          ease_dollars((-G.GAME.dollars - 20), true)
        end
      return true end }))
    end
  end,
}

-- Antisoul
SMODS.Consumable {
  set = 'Antispectral',
  key = 'antisoul',
  unlocked = true,
  discovered = false,
  loc_txt = {
    name = 'Antisoul',
    text = { 
      'Creates a {C:dark_edition}Negative{}',
      '{C:legendary,E:1}Legendary{} Joker{},',
      '+1 Ante',
      '{C:inactive}(Does not work on Ante 8)'
    }
  },
  pos = { x = 7, y = 1 },
  atlas = 'antispectral',
  cost = 8,
  can_use = function(self, card)
    if G.GAME.round_resets.ante ~= G.GAME.win_ante and G.STATE ~= G.STATES.SELECTING_HAND and
     G.STATE ~= G.STATES.HAND_PLAYED and G.STATE ~= G.STATES.DRAW_TO_HAND and G.STATE ~= G.STATES.PLAY_TAROT or any_state then
      if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
        return true
      end
    end
  end,
  use = function(self, card, area, copier)
    ease_ante(1)
    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante+1
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      play_sound('timpani')
      local card = create_card('Joker', G.jokers, true, nil, nil, nil, nil, 'antisou')
      card:set_edition({negative = true}, true, true)
      card:add_to_deck()
      G.jokers:emplace(card)
      check_for_unlock{type = 'spawn_legendary'}
    return true end }))
    delay(0.6)
  end,
}

-- White Hole
SMODS.Consumable {
  set = 'Antispectral',
  key = 'antihole',
  unlocked = true,
  discovered = false,
  loc_txt = {
    name = 'White Hole',
    text = { 
      "Upgrade every {C:legendary,E:1}poker",
      "{C:legendary,E:1}hand{} by {C:attention}3{} levels",
      "{C:red}Reset{} played stats",
      "for every hand"
    }
  },
  pos = { x = 6, y = 1 },
  atlas = 'antispectral',
  cost = 8,
  can_use = function(self, card)
    if G.STATE ~= G.STATES.HAND_PLAYED and G.STATE ~= G.STATES.DRAW_TO_HAND and G.STATE ~= G.STATES.PLAY_TAROT or any_state then
      return true
    end
  end,
  use = function(self, card, area, copier)
    for k, v in pairs(G.GAME.hands) do
      v.played = 0
      v.played_this_round = 0
    end
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
      play_sound('tarot1')
      card:juice_up(0.8, 0.5)
      G.TAROT_INTERRUPT_PULSE = true
    return true end }))
    update_hand_text({delay = 0}, {mult = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
      play_sound('tarot1')
      card:juice_up(0.8, 0.5)
    return true end }))
    update_hand_text({delay = 0}, {chips = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
      play_sound('tarot1')
      card:juice_up(0.8, 0.5)
      G.TAROT_INTERRUPT_PULSE = nil
    return true end }))
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+3'})
    delay(1.3)
    for k, v in pairs(G.GAME.hands) do
      level_up_hand(card, k, true, 3)
    end
    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
  end,
}