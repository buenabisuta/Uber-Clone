import React, { Fragment, useEffect, useReducer } from 'react'
import styled from 'styled-components'
import { Link } from 'react-router-dom'

import { fetchFoods } from '../apis/foods'
import { initialState as foodsInitialState, foodsActionTypes, foodsReducer } from '../reducer/foods'
import { REQUEST_STATE } from '../constants'

import { COLORS } from '../style_constants'
import { LocalMainIcon } from '../components/Icons'
import { FoodWrapper } from '../components/FoodWrapper'
import Skeleton from '@material-ui/lab/Skeleton'

import MainLogo from '../images/logo.png'
import FoodImage from '../images/food-image.jpg'

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

  const [foodState, dispatch] = useReducer(foodsReducer, foodsInitialState)

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
                  onClickWrapper={(food) => console.log(food)}
                  imageUrl={FoodImage} />
              </ItemWrapper>
            )
        }
      </FoodsList>
    </Fragment>
  )
}
