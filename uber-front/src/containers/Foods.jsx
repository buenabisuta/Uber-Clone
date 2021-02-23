import React, { Fragment, useEffect, useReducer, useState } from 'react'
import styled from 'styled-components'
import { Link, useHistory } from 'react-router-dom'

import { fetchFoods } from '../apis/foods'
import { initialState as foodsInitialState, foodsActionTypes, foodsReducer } from '../reducer/foods'
import { REQUEST_STATE } from '../constants'

import { COLORS } from '../style_constants'
import { LocalMainIcon } from '../components/Icons'
import { FoodWrapper } from '../components/FoodWrapper'
import Skeleton from '@material-ui/lab/Skeleton'

import MainLogo from '../images/logo.png'
import FoodImage from '../images/food-image.jpg'
import { FoodOrderDialog } from '../components/FoodOrderDialog'
import { NewOrderConfirmDialog } from '../components/NewOrderConfirmDialog'

import { postLineFoods, replaceLineFoods } from '../apis/line_foods'

import { HTTP_STATUS_CODE } from '../constants'

const HeaderWrapper = styled.div`
  display: flex;
  justify-content: space-between;
  padding: 8px 32px;
`

const BagIconWrapper = styled.div`
  padding-top: 24px;
`

const ColorBagIcon = styled(LocalMainIcon)`
  color: ${COLORS.MAIN};
`

const MainLogoImage = styled.img`
  height:90px;
`

const FoodsList = styled.div`
  display: flex;
  justify-content: space-around;
  flex-wrap: wrap;
  margin-bottom: 50px;
`

const ItemWrapper = styled.div`
  margin: 16px;
`

export const Foods = (props) => {

  const history = useHistory()

  const [foodState, dispatch] = useReducer(foodsReducer, foodsInitialState)

  const initialState = {
    isOpenOrderDialog: false,
    selectedFood: null,
    selectedFoodCount: 1,
    isOpenNewOrderDialog: false,
    existingRestaurantName: '',
    newRestaurantName: '',
  }

  const [state, setState] = useState(initialState)

  useEffect(() => {
    dispatch({ type: foodsActionTypes.FETCHING })
    fetchFoods(props.match.params.restaurantsId).then((data) =>
      dispatch({
        type: foodsActionTypes.FETCH_SUCCESS,
        payload: {
          foods: data.foods
        }
      })
    )
  }, [props])

  const submitOrder = () => {
    postLineFoods({
      foodId: state.selectedFood.id,
      count: state.selectedFoodCount,
    }).then(() => history.push('/orders'))
      .catch((e) => {
        if (e.response.status === HTTP_STATUS_CODE.NOT_ACCEPTABLE) {
          setState({
            ...state,
            isOpenOrderDialog: false,
            isOpenNewOrderDialog: true,
            existingRestaurantName: e.response.data.existing_restaurant,
            newRestaurantName: e.response.data.new_restaurant,
          })
        }
        else {
          throw e
        }
      })
  }

  const replaceOrder = () => {
    replaceLineFoods({
      foodId: state.selectedFood.id,
      count: state.selectedFoodCount,
    }).then(() => history.push('orders'))
  }

  return (
    <Fragment>
      <HeaderWrapper>
        <Link to='/restaurants'>
          <MainLogoImage src={MainLogo} alt='main logo' />
        </Link>
        <BagIconWrapper>
          <ColorBagIcon fontSize="large" />
        </BagIconWrapper>
      </HeaderWrapper>
      <FoodsList>
        {
          foodState.fetchState === REQUEST_STATE.LOADING ?
            <Fragment>
              {
                [...Array(12).keys()].map(i =>
                  <ItemWrapper key={i}>
                    <Skeleton key={i} variant="rect" width={450} height={180} />
                  </ItemWrapper>
                )
              }
            </Fragment>
            :
            foodState.foodsList.map(food =>
              <ItemWrapper key={food.id}>
                <FoodWrapper key={food.id}
                  food={food}
                  onClickWrapper={(food) => setState({
                    ...state,
                    isOpenOrderDialog: true,
                    selectedFood: food,
                  })}
                  imageUrl={FoodImage} />
              </ItemWrapper>
            )
        }
      </FoodsList>
      {
        state.isOpenOrderDialog &&
        <FoodOrderDialog
          food={state.selectedFood}
          countNumber={state.selectedFoodCount}
          onClickCountDown={() => setState({
            ...state,
            selectedFoodCount: state.selectedFoodCount - 1,
          })}
          onClickCountUp={() => setState({
            ...state,
            selectedFoodCount: state.selectedFoodCount + 1,
          })}
          onClickOrder={() => submitOrder()}
          isOpen={state.isOpenOrderDialog}
          onClose={() => setState({
            ...state,
            isOpenOrderDialog: false,
            selectedFood: null,
            selectedFoodCount: 1,
          })} />
      }
      {
        state.isOpenNewOrderDialog &&
        <NewOrderConfirmDialog
          isOpen={state.isOpenNewOrderDialog}
          onClose={() => setState({ ...state, isOpenNewOrderDialog: false })}
          existingRestaurantName={state.existingRestaurantName}
          newRestaurantName={state.newRestaurantName}
          onClickSubmit={() => replaceOrder()} />
      }
    </Fragment>
  )
}
