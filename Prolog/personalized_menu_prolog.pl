% Ingredients: ingredient(Name)
ingredient(prosciutto_crudo).
ingredient(salame).
ingredient(mortadella).
ingredient(coppa).
ingredient(gorgonzola).
ingredient(fontina).
ingredient(pecorino).
ingredient(farina).
ingredient(pomodoro).
ingredient(basilico).
ingredient(mozzarella).
ingredient(olio_oliva).
ingredient(spaghetti).
ingredient(penne).
ingredient(riso).
ingredient(pollo).
ingredient(manzo).
ingredient(uova).
ingredient(guanciale).
ingredient(funghi).
ingredient(zucchine).
ingredient(vongole).
ingredient(gamberetti).
ingredient(lattuga).
ingredient(cetriolo).
ingredient(olive).
ingredient(carota).

% Calories
calories(prosciutto_crudo, 150).
calories(salame, 200).
calories(mortadella, 250).
calories(coppa, 180).
calories(gorgonzola, 300).
calories(fontina, 280).
calories(farina, 340).
calories(pomodoro, 20).
calories(basilico, 5).
calories(mozzarella, 150).
calories(pecorino, 120).
calories(olio_oliva, 120).
calories(spaghetti, 350).
calories(penne, 360).
calories(riso, 330).
calories(pollo, 200).
calories(manzo, 250).
calories(uova, 70).
calories(guanciale, 200).
calories(funghi, 25).
calories(zucchine, 15).
calories(vongole, 180).
calories(gamberetti, 150).
calories(lattuga, 15).
calories(cetriolo, 16).
calories(olive, 115).
calories(carota, 41).

% Meals: meal(Name, [List of Ingredients])
meal(caprese, [mozzarella, pomodoro, basilico, olio_oliva]).
meal(tagliere_salumi, [prosciutto_crudo, salame, mortadella, coppa]).
meal(tagliere_formaggi, [gorgonzola, fontina, pecorino]).
meal(pizza_margherita, [farina, mozzarella, pomodoro, basilico, olio_oliva]).
meal(carbonara, [spaghetti, uova, pecorino, guanciale]).
meal(pasta_vegetariana, [penne, pomodoro, zucchine, funghi, olio_oliva]).
meal(pollo_grigliato, [pollo, olio_oliva]).
meal(tagliata_di_manzo, [manzo, olio_oliva]).
meal(insalata_mista, [lattuga, pomodoro, cetriolo, carota, olive, olio_oliva]).
meal(spaghetti_alle_vongole, [spaghetti, vongole, olio_oliva]).
meal(risotto_gamberetti, [riso, gamberetti, olio_oliva]).

% Calorie-conscious example threshold
calorie_threshold(600).

% Ingredients not compatible with a vegetarian diet
non_vegetarian(prosciutto_crudo).
non_vegetarian(salame).
non_vegetarian(mortadella).
non_vegetarian(coppa).
non_vegetarian(guanciale).
non_vegetarian(pollo).
non_vegetarian(manzo).
non_vegetarian(vongole).
non_vegetarian(gamberetti).

% Ingredients not compatible with a lactose intolerance
non_lactose(gorgonzola).
non_lactose(fontina).
non_lactose(pecorino).
non_lactose(mozzarella).

% Ingredients not compatible with a gluten intolerance
non_gluten(spaghetti).
non_gluten(penne).
non_gluten(farina).

% Vegetarian meal rule
is_vegetarian(Meal) :-
    meal(Meal, Ingredients),
    \+ (member(Ingredient, Ingredients), non_vegetarian(Ingredient)).

% Carnivore meal rule
is_carnivore(Meal) :- meal(Meal, _).

% Gluten intolerant meal rule
is_gluten_free(Meal) :-
    meal(Meal, Ingredients),
    \+ (member(Ingredient, Ingredients), non_gluten(Ingredient)).

% Lactose intolerant meal rule:
is_lactose_free(Meal) :-
    meal(Meal, Ingredients),
    \+ (member(Ingredient, Ingredients), non_lactose(Ingredient)).

% Calorie calculation for a meal
calculate_ingredients_calories([], 0).
calculate_ingredients_calories([Ingredient|RestOfIngredients], TotalCalories) :-
    calories(Ingredient, Calories), % get calories for current ingredient
    calculate_ingredients_calories(RestOfIngredients, RestCalories),
    TotalCalories is Calories + RestCalories.

meal_calories(Meal, TotalCalories) :-
    meal(Meal, Ingredients),
    calculate_ingredients_calories(Ingredients, TotalCalories).

% Determine if a meal is calorie-conscious
is_calorie_conscious(Meal) :-
    meal_calories(Meal, TotalCalories),
    calorie_threshold(Threshold),
    TotalCalories =< Threshold.

% Fits: associate a profile with a meal
fits(vegetarian, Meal) :- is_vegetarian(Meal).
fits(carnivore, Meal) :- is_carnivore(Meal).
fits(lactose_intolerant, Meal) :- is_lactose_free(Meal).
fits(gluten_intolerant, Meal) :- is_gluten_free(Meal).
fits(calorie_conscious, Meal) :- is_calorie_conscious(Meal).

% Collect meals that are compliant with all given preferences
recommend_meal(Profile, Meal) :-
    \+ is_list(Profile),
    fits(Profile, Meal).

recommend_meal(Profiles, Meal) :-
    is_list(Profiles),
    all_fit(Profiles, Meal).

% Helper to check all profiles fit
all_fit([], _).
all_fit([Preference|OtherPreferences], Meal) :-
    fits(Preference, Meal),
    all_fit(OtherPreferences, Meal).

% --- Query examples:
% ?- is_vegetarian(Meal).
% ?- is_gluten_free(Meal).
% ?- is_lactose_free(Meal).
% ?- is_calorie_conscious(Meal).

% ?- meal_calories(pizza_margherita, Calories).
% ?- fits(gluten_intolerant, spaghetti_alle_vongole).
% ?- recommend_meal([vegetarian], Meal).
% ?- recommend_meal([carnivore, gluten_intolerant], Meal).
% ?- recommend_meal([lactose_intolerant, calorie_conscious], Meal).
