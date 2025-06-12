% Ingredients: ingredient(Name)
ingredient(tomato).
ingredient(basil).
ingredient(mozzarella).
ingredient(parmesan).
ingredient(olive_oil).
ingredient(spaghetti).
ingredient(penne).
ingredient(rice).
ingredient(chicken).
ingredient(beef).
ingredient(egg).
ingredient(bacon).
ingredient(mushrooms).
ingredient(cream).
ingredient(zucchini).
ingredient(clams).
ingredient(shrimp).

% Calories
calories(tomato, 20).
calories(basil, 5).
calories(mozzarella, 150).
calories(parmesan, 120).
calories(olive_oil, 120).
calories(spaghetti, 350).
calories(penne, 360).
calories(rice, 330).
calories(chicken, 200).
calories(beef, 250).
calories(egg, 70).
calories(bacon, 300).
calories(mushrooms, 25).
calories(cream, 250).
calories(zucchini, 15).
calories(clams, 180).
calories(shrimp, 150).

% Meals: meal(Name, [List of Ingredients])
meal(pizza_margherita,     [mozzarella, tomato, basil, olive_oil]).
meal(carbonara,            [spaghetti, egg, cream, parmesan, bacon]).
meal(vegetarian_pasta,     [penne, tomato, zucchini, mushrooms, olive_oil]).
meal(grilled_chicken,      [chicken, olive_oil]).
meal(beef_steak,           [beef, olive_oil]).
meal(mixed_salad,          [tomato, zucchini, olive_oil, basil]).
meal(spaghetti_alle_vongole,[spaghetti, clams, olive_oil]).
meal(shrimp_risotto,       [rice, shrimp, olive_oil, parmesan]).

% Calorie-conscious example threshold
calorie_threshold(600).

% Ingredients not compatible with a vegetarian diet
non_vegetarian(bacon).
non_vegetarian(chicken).
non_vegetarian(beef).
non_vegetarian(clams).
non_vegetarian(shrimp).

% Ingredients not compatible with a lactose intolerance
non_lactose(mozzarella).
non_lactose(parmesan).
non_lactose(cream).

% Ingredients not compatible with a gluten intolerance
non_gluten(spaghetti).
non_gluten(penne).

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
all_fit([P|Ps], Meal) :-
    fits(P, Meal),
    all_fit(Ps, Meal).

% --- Query examples:
% ?- is_vegetarian(Meal).
% ?- is_gluten_free(Meal).
% ?- is_lactose_free(Meal).
% ?- is_calorie_conscious(Meal).

% ?- meal_calories(pizza_margherita, Calories).
% ?- fits(no_gluten, spaghetti_alle_vongole).
% ?- recommend_meal([vegetarian], Meal).
% ?- recommend_meal([carnivore, gluten_intolerant], Meal).
% ?- recommend_meal([lactose_intolerant, calorie_conscious], Meal).
