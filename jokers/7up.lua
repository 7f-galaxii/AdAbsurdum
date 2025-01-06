SMODS.Joker {
  key = '7up',
  config = { extra = { extra_mult = 7 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.extra_mult } }
  end,
  rarity = 3,
  atlas = 'AdAbsurdum',
  pos = { x = 1, y = 0 },
  cost = 9,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if context.other_card:get_id() == 7 then
        context.other_card.ability.bonus_mult = (context.other_card.ability.bonus_mult or 0) + card.ability.extra.extra_mult
        return {
          extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
          card = context.other_card
        }
      end
    end
  end
}


local old_Card_get_chip_mult = Card.get_chip_mult
function Card:get_chip_mult()
    local mult = old_Card_get_chip_mult(self)
    return mult + (self.ability.bonus_mult or 0)
end
