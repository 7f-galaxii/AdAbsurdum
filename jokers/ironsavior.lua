SMODS.Joker {
  key = 'ironsavior',
  config = { extra = { increase = 1 } },
  enhancement_gate = 'm_steel',
  loc_vars = function(self, info_queue, card)
    return { vars = { G.GAME.round_resets.ante*card.ability.extra.increase, card.ability.extra.increase } }
  end,
  rarity = 2,
  atlas = 'AdAbsurdum',
  pos = { x = 0, y = 0 },
  cost = 6,
  calculate = function(self, card, context)
    if context.end_of_round and context.game_over then
      local steel_cards = {}
      for index, p_card in ipairs(G.playing_cards) do
        if p_card.config.center == G.P_CENTERS.m_steel then table.insert(steel_cards, index) end
      end
      print(steel_cards)
      if #steel_cards >= (G.GAME.round_resets.ante*card.ability.extra.increase) then
        for i = 1, math.max(1,(G.GAME.round_resets.ante*card.ability.extra.increase)) do
          G.playing_cards[steel_cards[pseudorandom('ironsav', 1, #steel_cards)]]:start_dissolve(nil, i == 1)
        end
        G.E_MANAGER:add_event(Event({
          func = function()
            G.hand_text_area.blind_chips:juice_up()
            G.hand_text_area.game_chips:juice_up()
            play_sound('tarot1')
            return true
          end
        })) 
        return {
          message = localize('k_saved_ex'),
          saved = true,
          colour = G.C.RED
        }
      end
    end
  end
}
