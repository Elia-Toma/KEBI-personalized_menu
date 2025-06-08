% --- Ingredients: ingredient(Name, Category, Calories)
ingredient(tomato, vegetable, 20).
ingredient(basil, vegetable, 5).
ingredient(mozzarella, dairy, 150).
ingredient(parmesan, dairy, 120).
ingredient(olive_oil, fat, 120).
ingredient(spaghetti, gluten, 350).
ingredient(penne, gluten, 360).
ingredient(rice, grain, 330).
ingredient(chicken, meat, 200).
ingredient(beef, meat, 250).
ingredient(egg, protein, 70).
ingredient(bacon, meat, 300).
ingredient(mushrooms, vegetable, 25).
ingredient(cream, dairy, 250).
ingredient(zucchini, vegetable, 15).
ingredient(clams, seafood, 180).
ingredient(shrimp, seafood, 150).

% --- Meals: meal(Name, [List of Ingredients])
meal(pizza_margherita,     [mozzarella, tomato, basil, olive_oil]).
meal(carbonara,            [spaghetti, egg, cream, parmesan, bacon]).
meal(vegetarian_pasta,     [penne, tomato, zucchini, mushrooms, olive_oil]).
meal(grilled_chicken,      [chicken, olive_oil]).
meal(beef_steak,           [beef, olive_oil]).
meal(mixed_salad,          [tomato, zucchini, olive_oil, basil]).
meal(spaghetti_alle_vongole,[spaghetti, clams, olive_oil]).
meal(shrimp_risotto,       [rice, shrimp, olive_oil, parmesan]).

% --- Allergens: allergen(Ingredient, AllergenType)
allergen(mozzarella, lactose).
allergen(parmesan,   lactose).
allergen(spaghetti,  gluten).
allergen(penne,      gluten).
allergen(chicken,    meat).
allergen(beef,       meat).
allergen(egg,        egg).
allergen(bacon,      meat).
allergen(cream,      lactose).
allergen(clams,      seafood).
allergen(shrimp,     seafood).

% --- Calorie computation
calculate_ingredients_calories([], 0).
calculate_ingredients_calories([I|T], Total) :-
    ingredient(I, _, C),
    calculate_ingredients_calories(T, Rest),
    Total is C + Rest.

meal_calories(Meal, Total) :-
    meal(Meal, Ing),
    calculate_ingredients_calories(Ing, Total).

% --- Predicate member/2
member(X, [X|_]).
member(X, [_|T]) :- member(X, T).

% --- Vegetarian: there must be no meat or seafood ingredients
is_vegetarian(Meal) :-
    meal(Meal, Ing),
    \+ ( member(I, Ing), ingredient(I, meat, _) ),
    \+ ( member(I, Ing), ingredient(I, seafood, _) ).

% --- Carnivore: for simplicity's sake, anyone who eats meat or fish
is_carnivore(Meal) :-
    meal(Meal, Ing),
    member(I, Ing),
    ingredient(I, meat, _).
is_carnivore(Meal) :-
    meal(Meal, Ing),
    member(I, Ing),
    ingredient(I, seafood, _).

% --- Calorie conscious: calories <= Threshold
is_calorie_conscious(Meal, Thr) :-
    meal_calories(Meal, C),
    C =< Thr.

% --- Has allergen
has_allergen(Meal, A) :-
    meal(Meal, Ing),
    member(I, Ing),
    allergen(I, A).

% --- fits: associate a profile with a meal
fits(vegetarian, Meal)            :- is_vegetarian(Meal).
fits(carnivore, Meal)             :- is_carnivore(Meal).
fits(calorie_conscious(Thr), Meal):- is_calorie_conscious(Meal, Thr).
fits(no_lactose, Meal)            :- \+ has_allergen(Meal, lactose).
fits(no_gluten, Meal)             :- \+ has_allergen(Meal, gluten).
fits(no_seafood, Meal)            :- \+ has_allergen(Meal, seafood).

% --- Recommend a meal for a single profile
recommend_meal(Profile, Meal) :-
    \+ (Profile = [_|_]),  % non è una lista
    fits(Profile, Meal).

% --- Recommend a meal for multiple profiles (list)
recommend_meal([P|Ps], Meal) :-
    fits(P, Meal),
    recommend_meal(Ps, Meal).
recommend_meal([], _).  % base case

% --- Query examples:
% ?- recommend_meal([vegetarian, calorie_conscious(200)], M).
% ?- meal_calories(pizza_margherita, C).
% ?- fits(no_gluten, spaghetti_alle_vongole).