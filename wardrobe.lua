local FORM_NAME = "wardrobe_wardrobeSkinForm";
local SKIN_BUTTON_SIZE = 4;
local SKIN_BUTTON_SIZE_W = 4;
local FORM_X = 15;
local FORM_Y = 10;

local function showForm(player, page)
	local playerName = player:get_player_name();
	if not playerName or playerName == "" then return; end

	local n = #wardrobe.skins;
	if n <= 0 then return; end

	if not page or page > n then page = 1; end

	local fs = "size[6,8]";
	fs = fs.."label[0,0;Choose your look:]";
	local skin = wardrobe.skins[page];
	local skinButton = wardrobe.skins[page]:gsub(".png", "_btn.png");
	local skinName = minetest.formspec_escape(wardrobe.skinNames[skin]);
	--image_button[X,Y;W,H;image;name;label]
	fs = fs.."image_button_exit[1,2;4,4;"..skinButton..";s:"..skin..";]";
	fs = fs.."label[1,1;"..skinName.."]";
	fs = fs.."label[1,6;Skin "..page.."/"..n.."]";
	if page > 1 then
		fs = fs.."button[2,7;1,1;n:p"..(page-1)..";<]";
	end
	if page < n then
		fs = fs.."button[3,7;1,1;n:p"..(page+1)..";>]";
	end
	if page > 10 then
		fs = fs.."button[1,7;1,1;n:p"..(page-10)..";<<]";
	end
	if page < n-9 then
		fs = fs.."button[4,7;1,1;n:p"..(page+10)..";>>]";
	end

	minetest.show_formspec(playerName, FORM_NAME, fs);
end


minetest.register_on_player_receive_fields(
   function(player, formName, fields)
      if formName ~= FORM_NAME then return; end

      local playerName = player:get_player_name();
      if not playerName or playerName == "" then return; end

      for fieldName in pairs(fields) do
         if #fieldName > 2 then
            local action = string.sub(fieldName, 1, 1);
            local value = string.sub(fieldName, 3);

            if action == "n" then
               showForm(player, tonumber(string.sub(value, 2)));
               return;
            elseif action == "s" then
               wardrobe.changePlayerSkin(playerName, value);
               return;
            end
         end
      end
   end);


minetest.register_node(
   "wardrobe:wardrobe",
   {
      description = "Wardrobe",
      paramtype2 = "facedir",
      tiles = {
                 "wardrobe_wardrobe_topbottom.png",
                 "wardrobe_wardrobe_topbottom.png",
                 "wardrobe_wardrobe_sides.png",
                 "wardrobe_wardrobe_sides.png",
                 "wardrobe_wardrobe_sides.png",
                 "wardrobe_wardrobe_front.png"
              },
      inventory_image = "wardrobe_wardrobe_front.png",
      sounds = default.node_sound_wood_defaults(),
      groups = { choppy = 3, oddly_breakable_by_hand = 2, flammable = 3 },
      on_rightclick = function(pos, node, player, itemstack, pointedThing)
         showForm(player, 1);
      end
   });

--minetest.register_craft(
--   {
--      output = "wardrobe:wardrobe",
--      recipe = { { "group:wood", "group:stick", "group:wood" },
--                 { "group:wood", "group:wool",  "group:wood" },
--                 { "group:wood", "group:wool",  "group:wood" } }
--   });
