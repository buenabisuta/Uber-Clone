const DEFALT_API_LOCALHOST = 'http://localhost:3000/api/v1'

export const restaurantsIndex = `${DEFALT_API_LOCALHOST}/restaurants`
export const foodsIndex = (restaurantId) => `${DEFALT_API_LOCALHOST}/restaurants/${restaurantId}/foods`
export const lineFoods = `${DEFALT_API_LOCALHOST}/line_foods`
export const lineFoodsReplace = `${DEFALT_API_LOCALHOST}/line_foods/replace`
export const orders = `${DEFALT_API_LOCALHOST}/orders`

